require 'sinatra/base'
require 'json'

class MoodleAPI < Sinatra::Base
  set :logging, false

  before do
    content_type :json
  end

  post '/webservice/rest/server.php' do
    Thread.current["organisation"] = "example"

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
          course = MoodleCourse.create(course)
          %Q( [{"shortname":"#{course["shortname"]}","id":"#{course["id"]}"}] )
        end
      when 'core_group_create_groups'
        if params[:groups] && group = params[:groups]["0"]
          if group["name"].to_s.empty? ||
              group["courseid"].to_s.empty?
            raise
          end
          %Q( [{"name":"#{group["name"]}","id":"112233","courseid":"123456"}] )
        end
      when 'core_group_get_course_groups'
        if course_id = params[:courseid]
          if course_id.to_i == 0
            raise
          end
          course = MoodleCourse.find(params[:courseid])
          %Q( [{"id":"889977","name":"#{course['shortname']}","courseid":"#{params[:courseid]}"}] )
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

class MoodleCourse
  @@courses_by_shortname = {}
  @@course_id = 123456

  def self.create(course)
    @@course_id += 1
    course["id"] = @@course_id.to_s
    @@courses_by_shortname[ @@course_id.to_s ] = course
  end
  
  def self.find(id)
    @@courses_by_shortname[ id ]
  end
end
