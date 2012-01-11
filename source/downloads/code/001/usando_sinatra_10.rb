require 'rubygems'

gem 'sinatra', '1.0'
require 'sinatra'

get '/hi' do
  "Hello World!"
end