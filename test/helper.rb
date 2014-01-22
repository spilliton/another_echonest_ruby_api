require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'


unless ENV['NO_MOCKING']
  require 'webmock/test_unit'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'another_echonest_ruby_api'

class Test::Unit::TestCase

  def setup_test_credentials
    EchoNest.setup do |config|
      config.api_key = 'fart'
    end
  end

  def mock(name, path_and_query, status=200)
    dir = File.dirname(__FILE__) + "/webmock/#{name}.json"
    file = File.open(dir)
    body = file.read
    url = "#{EchoNest::Request::BASE_URL}#{path_and_query}"
    stub_request(:get, url).to_return(:status => status, :body => body)
  end

  def teardown
    EchoNest.instance_variable_set(:@config, nil)
    WebMock.reset!
  end

end
