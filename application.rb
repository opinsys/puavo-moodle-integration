$LOAD_PATH << './lib'

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/logger'
require 'yaml'
require 'json'
require 'rest-client'
require 'moodle'
require 'user'

CONFIG = YAML.load_file("config/application.yml")[ ENV['RACK_ENV'] ]

class PuavoMoodleIntegration < Sinatra::Base
  register(Sinatra::Logger)

  set :logger_level, :debug

  set YAML.load_file("config/application.yml")

  configuration = settings.send(ENV['RACK_ENV'])

  post '/webhook' do
    logger.debug "Webhook request"
    # FIXME: Authentication

    # Detect object type
    type = "user" if params.has_key?("user")
    type = "course" if params.has_key?("course")

    case type
    when "user"
      user = params[:user]
      # Create user
      # FIXME: was user already created?
      sync_user = User.find_by_puavo_id(user[:puavo_id])
      moodle = Moodle.new(configuration["moodle_server"], configuration["moodle_token"])

      case params[:action]
      when "create"
        response = moodle.create_user(user)
      when "destroy"
        response = moodle.delete_user(user)
      when "save"
        response = moodle.update_user(user)
      end
      if response.has_key?("exception")
        logger.debug "Failed to create user: " + user[:uid]
        logger.debug "Exception: " + response["exception"]
        logger.debug "Debuginfo: " + response["debuginfo"]
        status 422
        %Q{ {"message":"Failed to create user"} }
      elsif response.has_key?("username") && response.has_key?("id")
        %Q{ {"message":"User was successfully created"} }
      end
    when "course"
      course = params[:course]
      moodle = Moodle.new(configuration["moodle_server"], configuration["moodle_token"])

      case params[:action]
      when "create"
        response = moodle.create_course(course)
      end
      if response.has_key?("exception")
        logger.debug "Failed to create course: " + course[:puavo_id]
        logger.debug "Exception: " + response["exception"]
        logger.debug "Debuginfo: " + response["debuginfo"]
        status 422
        %Q{ {"message":"Failed to create course"} }
      elsif response.has_key?("shortname") && response.has_key?("id")
        %Q{ {"message":"Course was successfully created"} }
      end
    end
  end
end
