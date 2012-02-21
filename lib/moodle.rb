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

  def create_user
    @moodle.post( :wsfunction => 'core_user_create_users',
                  :users => {
                    "0" => {
                      "username" => "testusername6",
                      "password" => "testpassword6", 
                      "firstname" => "testfirstname6",
                      "lastname" => "testlastname6",
                      "email" => "testemail6@moodle.com",
                      "idnumber" => "testidnumber6",
                      "city" => "testcity6" } } )
  end
end
