require 'sinatra/base'
require 'sinatra/logger'
require 'yaml'
require 'json'

class PuavoMoodleIntegration < Sinatra::Base
  register(Sinatra::Logger)
  set :logger_level, :debug

  set YAML.load_file("config/application.yml")

  post '/webhook' do
    logger.debug "Webhook request"
  end
end
