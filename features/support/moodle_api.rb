require 'sinatra/base'
require 'json'

class MoodleAPI < Sinatra::Base
  set :logging, false

  before do
    content_type :json
  end

  post '/webservice/rest/server.php' do

  end

  Thread.new do
    run!
  end
end
