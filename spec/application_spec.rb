require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Application' do
  it "should post webhook" do
    post '/webhook'
    last_response.should be_ok
    last_response.body.should include('Hello World')
  end
end
