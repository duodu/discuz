class ArticlesController < ApplicationController
  #显示所有帖子列表
  def list
    @articles = Article.find(:all, :conditions => "id = top_id", :order => "last_edit_date DESC")
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end
  #发帖
  def publish
    @article = Article.new
    if !session[:user_id]
      redirect_to :action => "list"
      flash[:notice] = ["You need to login first"]
    end
  end
  #发帖提交
  def publish_submit
    @article = Article.new(params[:article])
    date = Time.new.strftime("%Y%m%d%H%M%S")
    @article.submit_date = date
    @article.last_edit_date = date
    if session[:user_id]
      @article.user_id = session[:user_id]
      if @article.save
        id = @article.id
        @article.update_attributes(:top_id => id)
        redirect_to :action => "show", :id => id
        flash[:notice] = ["Successfully published"]
      else
        redirect_to :action => "publish"
        flash[:notice] = @article.errors.full_messages
      end
    else
      redirect_to :action => "list"
      flash[:notice] = ["You need to login first"]
    end 
  end
  #回帖
  def post
    top_id = params[:id]
    @article = Article.new(params[:article])
    @article.title = "COMMENT"
    @article.top_id = top_id
    date = Time.new.strftime("%Y%m%d%H%M%S")
    @article.submit_date = date
    @article.last_edit_date = date
    @article.user_id = session[:user_id]
    if @article.save
      redirect_to :action => "show", :id => top_id
      flash[:notice] = ["Successfully post"]
    else
      flash[:notice] = @article.errors.full_messages
      redirect_to :action => "show", :id => top_id
    end
  end
  #编辑帖子
  def edit
    @article = Article.find(params[:id])
    @user = User.find(session[:user_id])
    if @article.user_id != @user.id
      redirect_to :action => "list"
    end
  end
  #编辑帖子提交
  def edit_submit
    @article = Article.find(params[:id])
    date = Time.new.strftime("%Y%m%d%H%M%S")
    if session[:user_id] == @article.user_id
      if @article.update_attributes(params[:article])
        @article.update_attributes(:last_edit_date => date)
        redirect_to :action => "show", :id => @article.top_id
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
    
  end
  #查看帖子
  def show
    top_id = params[:id]
    @articles = Article.where(["top_id = ?", top_id])
    if @articles.empty?
      redirect_to :action => "list"
    end
    @article = Article.new
  end
end
