When /^I POST to "(.+)" using JSON$/ do |path, *body|
  body = JSON.parse(body.first)
  page.driver.post(path, body)
end
