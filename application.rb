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

  configuration = settings.send(ENV['RACK_ENV'])

  post '/webhook' do
    logger.debug "Webhook request"
    # FIXME: Authentication

    # Create user
    moodle = Moodle.new(configuration["moodle_server"], configuration["moodle_token"])
    puts moodle.create_user
    
    case params.keys.first
    when "user"
      %Q{ {"message":"User was successfully created"} }
    when "course"
    end
  end
end
