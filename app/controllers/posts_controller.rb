class PostsController < ApplicationController
  
  before_filter :check_admin, :except => :index
  
  def index
    @title = "News Archive"
    @posts = Post.paginate(:page => params[:page])
  end
    
  
  def new
    @title = "New Post"
    @post = Post.new
    if request.post?
      @post = Post.new(params[:post])
      if @post.save
        flash[:notice] = "New post is live"
        redirect_to :controller=>:site, :action=>:index
      else
        flash[:error] = "Something went wrong"
      end
    end
  end
  
  def check_admin
    if current_user_admin?
      return true
    end
    flash[:error] = "You don't have permissions to do that."
    redirect_to :controller=>:site, :action=>:index
    return
  end
  
end
