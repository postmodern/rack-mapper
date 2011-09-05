gem 'rspec', '~> 2.4'
require 'rspec'
require 'helpers/models'

require 'dm-core'
require 'dm-migrations'
require 'tempfile'

RSpec.configure do |rspec|
  rspec.before(:suite) do
    DataMapper.setup(:default, {
      :adapter => 'sqlite3',
      :path => Tempfile.new('rack-mapper').path
    })
    DataMapper.auto_migrate!
  end
end
