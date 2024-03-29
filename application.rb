$LOAD_PATH << './lib'

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/logger'
require 'yaml'
require 'json'
require 'rest-client'
require 'moodle'
require 'user'
require 'course'
require 'hmac-sha1'

ORGANISATIONS_CONFIGURATION = YAML.load_file("config/application.yml")

class PuavoMoodleIntegration < Sinatra::Base
  register(Sinatra::Logger)

  set :logger_level, :debug

  post '/webhook' do
    logger.debug "Webhook request"
    
    payload = JSON.parse params[:payload]

    unless payload.has_key?('organisation') &&
        payload.has_key?('action') &&
        ( payload.has_key?('user') ||
          payload.has_key?('course') )
      status 422
      return %Q{ {"message":"Invalid parameters"} }
    end

    CONFIG = ORGANISATIONS_CONFIGURATION[ payload["organisation"] ]

    # Authentication
    unless HMAC::SHA1.hexdigest( CONFIG["private_api_key"],
                                 params[:payload] ) == params[:hmac]
      logger.debug "Authentication failed"
      status 422
      return %Q{ {"message":"Authentication failed"} }
    end

    Thread.current["organisation"] = payload["organisation"]

    # Detect object type
    type = "user" if payload.has_key?("user")
    type = "course" if payload.has_key?("course")

    case type
    when "user"
      user = payload["user"]
      # Create user
      # FIXME: was user already created?
      sync_user = User.find_by_puavo_id(user["puavo_id"])
      moodle = Moodle.new(CONFIG["moodle_server"], CONFIG["moodle_token"])

      begin
        case payload["action"]
        when "create"
          response = moodle.create_user(user)
          if response.has_key?("exception")
            raise  %Q{ {"message":"Failed to create user"} }
          elsif response.has_key?("username") && response.has_key?("id")
            return %Q{ {"message":"User was successfully created"} }
          end
        when "destroy"
          response = moodle.delete_user(user)
          if response.has_key?("exception")
            raise  %Q{ {"message":"Failed to delete user"} }
          else
            return %Q{ {"message":"User was successfully deleted"} }
          end
        when "update"
          response = moodle.update_user(user)
          if response.has_key?("exception")
            raise  %Q{ {"message":"Failed to update user"} }
          else
            return %Q{ {"message":"User was successfully updated"} }
          end
        end
      rescue Exception => e
        logger.debug e.to_s
        logger.debug user.inspect
        logger.debug "uid: " + user["uid"]
        logger.debug "Exception: " + response["exception"]
        logger.debug "Debuginfo: " + response["debuginfo"]
        status 422
        %Q{ {"message":"Failed to create, update or delete user"} }
      end
    when "course"
      course = payload["course"]
      moodle = Moodle.new(CONFIG["moodle_server"], CONFIG["moodle_token"])

      begin
        case payload["action"]
        when "create"
          response = moodle.create_course(course)
          if response.has_key?("shortname") && response.has_key?("id")
            response = moodle.create_course_group( "name" => response["shortname"],
                                                   "courseid" => response["id"],
                                                   "description" => "",
                                                   "enrolmentkey" => "" )
            unless response.has_key?("id") && response.has_key?("courseid")
              raise %Q{ {"message":"Failed to create course group"} }
            end
            return %Q{ {"message":"Course was successfully created"} }
          else
            raise  %Q{ {"message":"Failed to create course"} }
          end
        when "update"
          # Course update is not implemented: Moodle 2.2.2 (Build: 20120312)
        end
      rescue Exception => e
        logger.debug e.to_s
        logger.debug "puavo_id: " + course["puavo_id"].to_s
        logger.debug "Exception: " + response["exception"].to_s
        logger.debug "Debuginfo: " + response["debuginfo"].to_s
        status 422
        %Q{ {"message":"Failed to create, update or delete course"} }
      end
    end
  end
end
