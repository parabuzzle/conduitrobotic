class SiteController < ApplicationController
  def index
    @post = Post.last
    @title = "I am the Bit Crusher"
  end
  
  def about
    @title="About"
  end
  
  def contact
    @title="Contact"
  end
  
end
