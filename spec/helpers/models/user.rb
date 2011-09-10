require 'dm-core'

class User

  include DataMapper::Resource

  property :id, Serial

  property :name, String

  has n, :posts

  has n, :comments, :through => :posts

  def some_action
  end

  def get_and_post
  end

  def self.class_only
  end

  def self.instance_and_class
  end

  def instance_and_class
  end

  def custom_name
  end

end
