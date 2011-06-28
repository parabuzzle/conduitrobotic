class AdminController < ApplicationController
  layout "admin"
  
  before_filter :require_admin
  
  
  def index
    @title="Admin Dashboard"
  end
  
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
  
  def require_admin
    if current_user_admin?
      return true
    end
    flash[:error] = "You must be an admin to view this page"
    redirect_to :controller=>:site, :action=>:index
  end
end
