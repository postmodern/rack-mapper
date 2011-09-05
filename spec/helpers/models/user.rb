require 'dm-core'

class User

  include DataMapper::Resource

  property :id, Serial

  property :name, String

  has n, :posts

  has n, :comments, :through => :posts

end
