# REST client for Moodle 2
#
class Moodle

  def initialize(url, token)
    @moodle = RestClient::Resource.new( "#{url}/webservice/rest/server.php" +
                                        "?wstoken=#{token}" +
                                        "&moodlewsrestformat=json",
                                        :headers => {
                                          :content_type => "application/json; charset=utf-8" } )
  end

  def create_user(user)
    moodle_user = convert_puavo_user_to_moodle_user(user)
    response = @moodle.post( :wsfunction => 'core_user_create_users',
                             :users => {
                               "0" => moodle_user } )
    response = JSON.parse(response)
    response = response.class == Array ? response.first : response
    if response.has_key?("username") && response.has_key?("id")
      User.create!(:puavo_id => user["puavo_id"], :moodle_id => response["id"])
    end
    return response
  end

  def update_user(user)
    moodle_user = convert_puavo_user_to_moodle_user(user)
    sync_user = User.find_by_puavo_id(user["puavo_id"])
    moodle_user["id"] = sync_user.moodle_id
    response = @moodle.post( :wsfunction => 'core_user_update_users',
                             :users => {
                               "0" => moodle_user } )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    response.class == Array ? response.first : response
  end

  def delete_user(user)
    sync_user = User.find_by_puavo_id(user["puavo_id"])
    response = @moodle.post( :wsfunction => 'core_user_delete_users',
                             :userids => {
                               "0" => sync_user.moodle_id } )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    response = response.class == Array ? response.first : response
    unless response.has_key?("exception")
      User.find_by_puavo_id_and_moodle_id(sync_user.puavo_id, sync_user.moodle_id).destroy
    end
    response
  end

  def get_user(user)
    sync_user = User.find_by_puavo_id(user["puavo_id"])
    response = @moodle.post( :wsfunction => 'core_user_get_users_by_id',
                             :userids => {
                               "0" => sync_user.moodle_id } )
    response = JSON.parse(response)
    response.class == Array ? response.first : response
  end

  def create_course(course)
    moodle_course = convert_puavo_course_to_moodle_course(course)
    response = @moodle.post( :wsfunction => 'core_course_create_courses',
                             :courses => {
                               "0" => moodle_course } )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    response = response.class == Array ? response.first : response
    if response.has_key?("shortname") && response.has_key?("id")
      Course.create!(:puavo_id => course["puavo_id"], :moodle_id => response["id"])
    end
    return response
  end

  # Course update is not implemented: Moodle 2.2.2 (Build: 20120312)
  def update_course(course)
    moodle_course = convert_puavo_course_to_moodle_course(course)
    sync_course = Course.find_by_puavo_id(course["puavo_id"])
    moodle_course["id"] = sync_course.moodle_id
    response = @moodle.post( :wsfunction => 'core_course_update_courses',
                             :courses => {
                               "0" => moodle_course } )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    response.class == Array ? response.first : response
  end

  # Course delete is not implemented: Moodle 2.2.2 (Build: 20120312)
  def delete_course(puavo_id, moodle_id)
    response = @moodle.post( :wsfunction => 'core_course_delete_courses',
                             :courseids => {
                               "0" => moodle_id } )
    response = JSON.parse(response)
    response = response.class == Array ? response.first : response
    unless response.has_key?("exception")
      Course.find_by_puavo_id_and_moodle_id(puavo_id, moodle_id).destroy
    end
  end

  def create_course_group(group)
    response = @moodle.post( :wsfunction => 'core_group_create_groups',
                             :groups => {
                               "0" => group } )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    response = response.class == Array ? response.first : response
    if response.has_key?("id") && response.has_key?("courseid")
      course = Course.find_by_moodle_id( group["courseid"] )
      course.moodle_group_id = response["id"]
      course.save!
    end
    return response
  end

  def get_group_by_course_id(course_id)
    response = @moodle.post( :wsfunction => 'core_group_get_course_groups',
                             :courseid => course_id )
    if response == "null"
      response = {}
    else
      response = JSON.parse(response)
    end
    return response.class == Array ? response.first : response
  end

  private

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

  def convert_puavo_course_to_moodle_course(course)
    
    moodle_course = {
      "fullname" => course["name"],
      "shortname" => course["course_id"],
      "categoryid" =>  ORGANISATIONS_CONFIGURATION[Thread.current["organisation"]]["course_category_id"] }
    moodle_course
  end
end
