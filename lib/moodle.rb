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
    response = @moodle.post( :wsfunction => 'core_user_create_users',
                             :users => {
                               "0" => user } )
    response = JSON.parse(response)
    response.class == Array ? response.first : response
  end
end
