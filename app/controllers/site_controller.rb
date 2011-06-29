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
  
  def media
    @title = "Media"
  end
  
  def press
    @title = "Press"
  end
  
  def shows
    @title = "Shows"
  end
  
  def epk
    @title = "Electronic Press Kit"
  end
  
end
