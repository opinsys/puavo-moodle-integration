Before do
  # User.all.map &:destroy
  configuration = YAML.load_file("config/application.yml")[ ENV['RACK_ENV'] ]
  moodle = Moodle.new(configuration["moodle_server"], configuration["moodle_token"])
  User.all.each do |user|
    moodle.delete_user(user.puavo_id, user.moodle_id)
  end
end

When /^Puavo POST to "(.+)" using JSON$/ do |path, *body|
  body = JSON.parse(body.first)
  page.driver.post(path, body)
end
