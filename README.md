# rack-mapper

* [Homepage](http://rubygems.org/gems/rack-mapper)
* [Documentation](http://rubydoc.info/gems/rack-mapper/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

A Rack middleware which allows mapping DataMapper models and their
methods to RESTful Rack routes.

## Features

## Examples

    require 'rack/mapper'

    use Rack::Mapper do
    end

## Requirements

* [rack](http://github.com/rack/rack) ~> 1.0
* [dm-core](http://github.com/datamapper/dm-core) ~> 1.0
* [dm-serializer](http://github.com/datamapper/dm-serializer) ~> 1.0

## Install

    $ gem install rack-mapper

## Copyright

Copyright (c) 2011 Hal Brodigan

See {file:LICENSE.txt} for details.
