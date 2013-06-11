class UsersController < ApplicationController
  #查看用户信息
  def show
    @user=User.find(params[:id])
  end
  #编辑用户信息
  def edit
    @user=User.find(params[:id])
    if @user.id != session[:user_id]
      redirect_to :controller => "articles", :action => "list"
      flash[:notice] = ["You are not the one"]
    end
  end
  #编辑用户信息提交
  def edit_submit
    @user=User.find(params[:id])
    if @user.id == session[:user_id]
      if @user.update_attributes(params[:user])
        redirect_to :controller => "articles", :action => "list"
        flash[:notice] = ["Successfully edited"]
      else
        redirect_to :action => "edit", :id => @user.id
        flash[:notice] = @user.errors.full_messages
      end
    else
      redirect_to :controller => "articles", :action => "list"
      flash[:notice] = ["You are not the one!"]
    end
  end
  #注册用户
  def reg
    @user=User.new
  end
  #注册提交
  def reg_submit
    @user=User.new(params[:user])
    @user.rank_id=1
    if @user.save
      session[:user_id]=@user.id
      redirect_to :controller => "articles", :action => "list"
      flash[:notice] = ["Successfully registed"]
    else
      render :action => "reg"
    end
  end
  #登录
  def login
    uname=request[:name]
    upass=request[:password]
    user=User.find_by_name_and_password(uname,upass)
    session[:user_id]=nil
    if user
      session[:user_id]=user.id
      @user=User.find(user.id)
      flash[:notice] = ["Successfully login"]
      respond_to do |format|
        format.html { render :layout => false }
        format.xml { render :xml => @users}
      end
      #redirect_to :controller => "articles", :action => "list"
    else
      redirect_to :controller => "articles", :action => "list"
      flash[:notice] = ["login failed"]
    end
  end
  #注销用户
  def logout
    session[:user_id]=nil
    redirect_to :controller => "articles", :action => "list"
  end
end
