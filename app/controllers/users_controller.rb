class UsersController < ApplicationController
  def index
    @title = "Dashboard"
    unless session[:user_id]
      flash[:error] = "You must be logged in to view that page."
      redirect_to :action=>:login
      return
    end
  end
  
  def login
    unless request.post?
      @title = "Login"
      return
    end
    user = params['user']
    @user = User.find_by_email_and_password(user['email'], encrypt(user['password']))
    unless @user.nil?
      login!(@user)
      flash[:notice] = "Successfully logged in as #{@user.email}"
      redirect_to :action=>:index
      return
    else
      flash[:error] = "Email or Password does not match our records, please try again."
      render :login
      return
    end
  end
  
  def register
    unless request.post?
      @title = "Register"
      return
    end
    user = params[:user]
    if user[:password] != user[:confirm_password]
      flash[:error] = "Passwords do not match."
      return
    end
    @user = User.new(:email=>user[:email])
    @user.password = encrypt(user[:password])
    if @user.save
      flash[:notice] = "Successfully created user #{@user.email}"
      login!(@user)
      redirect_to :action=>:index
      return
    else
      flash[:error] = "Something went wrong"
      return
    end    
  end
  
  def login!(user)
    session[:user_id] = user.id
    session[:email] = user.email
    @user = User.find(user.id)
    @user.temp_token = nil
    @user.save
  end
    
  
  def logout
    @title = "Logout"
    reset_session
    flash[:notice] = "Successfully logged out. See you next time."
    redirect_to :controller=>:site, :action=>:index
  end
  
  def forgot_password
    @title = "Forgot Password"
    
  end
  
  def verify_email
    @title = "Verify Email"
    
  end
  
end
