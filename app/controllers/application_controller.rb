class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  def current_user_admin?
    if session[:user_id].nil?
      return false
    end
    @user = User.find(session[:user_id])
    if @user.is_admin == true
      return true
    end
    return false
  end
  
end
