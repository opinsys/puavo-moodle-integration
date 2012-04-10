require 'sinatra/base'
require 'json'

class MoodleAPI < Sinatra::Base
  set :logging, false

  before do
    content_type :json
  end

  post '/webservice/rest/server.php' do
    begin
      case params[:wsfunction]
      when 'core_user_create_users'
        if params[:users] && user = params[:users]["0"]
          if user["username"].to_s.empty? ||
              user["firstname"].to_s.empty? ||
              user["lastname"].to_s.empty? ||
              user["email"].to_s.empty? ||
            user["idnumber"].to_s.empty?
            raise
          end
        end
        %Q( [{"username":"#{user["username"]}","id":"123456"}] )
      when 'core_user_update_users'
        if params[:users] && user = params[:users]["0"]
          if user["username"].to_s.empty? ||
              user["firstname"].to_s.empty? ||
              user["lastname"].to_s.empty? ||
              user["email"].to_s.empty? ||
            user["idnumber"].to_s.empty?
            raise
          end
        end
        "null"
      when 'core_user_delete_users'
        "null"
      when 'core_course_delete_courses'
        "null"
      when 'core_course_create_courses'
        if params[:courses] && course = params[:courses]["0"]
          if course["fullname"].to_s.empty? ||
              course["shortname"].to_s.empty?
            raise
          end
           %Q( [{"shortname":"#{course["shortname"]}","id":"123456"}] )
        end
      when 'core_group_create_groups'
        if params[:groups] && group = params[:groups]["0"]
          if group["name"].to_s.empty? ||
              group["courseid"].to_s.empty?
            raise
          end
          %Q( [{"name":"#{group["name"]}","id":"112233","courseid":"123456"}] )
        end
      else
        raise
      end
    rescue
      status 422
      %Q( {"exception":"error","debuginfo":"error"} )
    end
  end

  Thread.new do
    run!
  end
end
