class SessionsController < ApplicationController
  skip_before_action :set_current_user
  skip_before_action :authenticate!
  
  def create   
    auth = request.env['omniauth.auth']   
    user = Moviegoer.where(provider: auth['provider'], uid: auth['uid'] ).first 
    
    unless user     
      user = Moviegoer.create_with_omniauth(auth)   
    end   
    
    session[:user_id] = user.id   
    redirect_to movies_path
  end
  
  def failure   
    flash[:notice] = 'Could not login'   
    redirect_to root_path
  end
  
  def destroy   
    session.delete(:user_id)   
    flash[:notice] = 'Logged out successfully'   
    redirect_to movies_path
  end
  
  def loginbefore
      flash[:notice] = 'Login'
      redirect_to root_path
  end
end

