$LOAD_PATH << './lib'

require 'sinatra/base'
require 'sinatra/logger'
require 'yaml'
require 'json'
require 'rest-client'
require 'moodle'

class PuavoMoodleIntegration < Sinatra::Base
  register(Sinatra::Logger)
  set :logger_level, :debug

  set YAML.load_file("config/application.yml")

  post '/webhook' do
    logger.debug "Webhook request"

    # FIXME: Authentication

    # Create user
    #moodle = Moodle.new(settings.moodle_server, settings.moodle_token)
    #puts moodle.create_user
    "Hello World"
  end
end
