Before do
  moodle = Moodle.new(CONFIG["moodle_server"], CONFIG["moodle_token"])
  User.all.each do |user|
    moodle.delete_user({ :puavo_id => user.puavo_id })
  end
  Course.all.each do |course|
    moodle.delete_course(course.puavo_id, course.moodle_id)
  end
end

When /^Puavo POST to "(.+)" using JSON$/ do |path, *body|
  body = JSON.parse(body.first)
  visit "/"
  page.driver.post(path, body)
end
