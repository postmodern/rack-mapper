require 'sinatra/base'

class App < Sinatra::Base

  get '/' do
    'Root'
  end

  get '/blog' do
    'Blog'
  end

  get '/users/register' do
    'Register'
  end

  post '/users/register' do
    'Registered'
  end

end
