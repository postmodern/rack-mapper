require 'dm-core'

class Post

  include DataMapper::Resource

  property :id, Serial

  property :title, String

  property :body, Text

  belongs_to :user

  has n, :comments

end
