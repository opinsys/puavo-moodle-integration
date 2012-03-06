ENV['RACK_ENV'] = "test"
# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'application.rb')

# Load the testing libraries
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
end

def app
  PuavoMoodleIntegration
end
