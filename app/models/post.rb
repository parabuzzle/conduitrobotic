class Post < ActiveRecord::Base
  self.per_page = 5
  default_scope :order => 'created_at DESC'
end
