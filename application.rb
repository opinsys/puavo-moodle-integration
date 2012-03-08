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

    
    case params.keys.first
    when "user"
      user = convert_puavo_user_to_moodle_user(params[:user])
      # Create user
      # FIXME: was user already created?
      moodle = Moodle.new(configuration["moodle_server"], configuration["moodle_token"])
      response = moodle.create_user(user)
      if response.has_key?("exception")
        logger.debug "Failed to create user: " + params[:user][:uid]
        logger.debug "Exception: " + response["exception"]
        logger.debug "Debuginfo: " + response["debuginfo"]
        status 422
        %Q{ {"message":"Failed to create user"} }
      elsif response.has_key?("username") && response.has_key?("id")
        %Q{ {"message":"User was successfully created"} }
      end
    when "course"
    end
  end

  def convert_puavo_user_to_moodle_user(user)
    moodle_user = {
      "username" => user["uid"],
      "firstname" => user["given_name"],
      "lastname" => user["surname"],
      "email" => user["email"],
      "idnumber" => user["puavo_id"] }

    # FIXME: remove useless integration data
    moodle_user["city"] = "test"
    moodle_user["password"] = " "
    moodle_user
  end
end
