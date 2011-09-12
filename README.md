# rack-mapper

* [Homepage](http://rubygems.org/gems/rack-mapper)
* [Documentation](http://rubydoc.info/gems/rack-mapper/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

A Rack middleware which allows mapping DataMapper models and their
methods to RESTful Rack routes.

## Features

## Examples

    require 'dm-core'

    class Post
    
      include DataMapper::Resource

      property :id, Serial

      property :title, String

      property :body, Text

      belongs_to :user

      def summary(n)
        self.body.split(/s+/,n).take(n).join(' ') + ' ...'
      end

    end

    class User

      include DataMapper::Resource

      property :id, Serial

      property :name, String

      has n, :posts

    end

    require 'rack/mapper'

    use Rack::Mapper do
      map User
      map Post do
        get :summary, :params => [:n]
      end
    end
    # GET    /users
    # GET    /users/1
    # GET    /posts
    # GET    /posts/1
    # GET    /posts/1/summary?n=100

## Requirements

* [rack](http://github.com/rack/rack) ~> 1.0
* [virtus](http://github.com/solnic/virtus) ~> 0.0
* [dm-core](http://github.com/datamapper/dm-core) ~> 1.0
* [dm-serializer](http://github.com/datamapper/dm-serializer) ~> 1.0

## Install

    $ gem install rack-mapper

## Copyright

Copyright (c) 2011 Hal Brodigan

See {file:LICENSE.txt} for details.
