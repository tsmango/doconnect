class UsersController < ApplicationController
  
  
  def index
    if logged_in? and current_user.id == 1
      @users = User.ordered.all
    else
      redirect_to root_path
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      UserSession.create(@user)
      
      flash[:notice] = 'Welcome to doconnect.me'
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
end
