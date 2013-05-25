class ArticlesController < ApplicationController
  #显示所有帖子列表
  def list
    #找出所有top_id=id的文章（即发布的文章，并非回复），并按照时间倒序排序
    @articles = Article.find(:all, :conditions => "id = top_id", :order => "last_edit_date DESC")
    #如果用户登录，获取用户信息
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end
  #发帖
  def publish
    #发布新文章
    @article = Article.new
    #如果用户未登录，回到首页，并提示登录
    if !session[:user_id]
      redirect_to :action => "list"
      flash[:notice] = ["You need to login first"]
    end
  end
  #发帖提交
  def publish_submit
    @article = Article.new(params[:article])
    #获取当前时间
    date = Time.new.strftime("%Y%m%d%H%M%S")
    #文章创建时间，和最后更新时间设为文章发布时间
    @article.submit_date = date
    @article.last_edit_date = date
    #如果用户登录，发布文章并且跳转到该文章
    if session[:user_id]
      @article.user_id = session[:user_id]
      if @article.save
        id = @article.id
        @article.update_attributes(:top_id => id)
        redirect_to :action => "show", :id => id, :num => 5
        flash[:notice] = ["Successfully published"]
      else
        redirect_to :action => "publish"
        flash[:notice] = @article.errors.full_messages
      end
    #未登录则回到首页并提示登录
    else
      redirect_to :action => "list"
      flash[:notice] = ["You need to login first"]
    end 
  end
  #回帖
  def post
    top_id = params[:id]
    @article = Article.new(params[:article])
    #回复的文章，名字默认设为“COMMENT”
    @article.title = "COMMENT"
    @article.top_id = top_id
    date = Time.new.strftime("%Y%m%d%H%M%S")
    #设置回复文章的编辑时间
    @article.submit_date = date
    @article.last_edit_date = date
    #如果登录则回复，并且更新置顶文章的最后更新时间
    if @article.user_id = session[:user_id]
      if @article.save
        @top = Article.find(params[:id])
        @top.update_attributes(:last_edit_date => date)
        redirect_to :action => "show", :id => top_id, :num => 5
        flash[:notice] = ["Successfully post"]
      else
        flash[:notice] = @article.errors.full_messages
        redirect_to :action => "show", :id => top_id, :num => 5
      end
    else
      redirect_to :action => "list"
      flash[:notice] = ["You need to login first"]
    end
  end
  #编辑帖子
  def edit
    @article = Article.find(params[:id])
    @user = User.find(session[:user_id])
    @num = params[:num]
    if @article.user_id != @user.id
      redirect_to :action => "list"
    end
  end
  #编辑帖子提交
  def edit_submit
    @article = Article.find(params[:id])
    date = Time.new.strftime("%Y%m%d%H%M%S")
    #更新帖子的时间
    if session[:user_id] == @article.user_id
      if @article.update_attributes(params[:article])
        @article.update_attributes(:last_edit_date => date)
        redirect_to :action => "show", :id => @article.top_id, :num => 5
        flash[:notice] = ["Successfully updated"]
      else
        redirect_to :action => "edit", :id => @article.id
        flash[:notice] = @article.errors.full_messages
      end
     else
       redirect_to :action => "list"
    end
  end
  #删帖
  def delete
    @article = Article.find(params[:id])
    if @article.user_id == session[:user_id]
      @article.destroy
      redirect_to :action => "list"
      flash[:notice] = ["Your title has been deleted"]
    else
      redirect_to :action => "list"
      flash[:notice] = ["You are not the one"]
    end
  end
  #查看帖子
  #可以分页查看，每页5条
  def show
    top_id = params[:id]
    @num = params[:num]
    @articles = Article.where(["top_id = ?", top_id]).limit(5).offset(@num.to_i-5)
    if @articles.empty?
      redirect_to :action => "list"
    end
    @next_page = false
    @prev_page = false
    if Article.where(["top_id = ?", top_id]).last.id > @articles.last.id
      @next_page = true
    end
    if Article.where(["top_id = ?", top_id]).first.id < @articles.first.id
      @prev_page = true
    end
    @article = Article.new
  end
end
