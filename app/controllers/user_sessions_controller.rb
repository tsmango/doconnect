class UserSessionsController < ApplicationController
  
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true
    
    if @user_session.save
      redirect_to root_path
    else
      @user_session.errors.clear
      
      flash[:notice] = 'The email address and password you entered are not correct.'
      render :action => 'new'
    end
  end
  
  def destroy
    if logged_in?
      current_user_session.destroy
    end
    
    redirect_to root_path
  end
end
