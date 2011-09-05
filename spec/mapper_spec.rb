require 'spec_helper'
require 'helpers/app'

require 'rack/mapper'

describe Rack::Mapper do
  subject do
    Rack::Mapper.new(App.new) do
      map User
      map Post, :map => 'blog/posts'
      map Comment
    end
  end

  it "should register Resources" do
    subject.resources.should have_key(User)
  end

  it "should infer the path for the resources from the Model name" do
    subject.routes[['users']].should == User
  end

  it "should allow overriding the path of the resource" do
    subject.routes[['blog','posts']].should == Post
  end
end
