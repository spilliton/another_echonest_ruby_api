module EchoNest
  autoload :Config, 'another_echonest_ruby_api/config'
  autoload :Request, 'another_echonest_ruby_api/request'
  autoload :Query, 'another_echonest_ruby_api/query'
  autoload :RequestException, 'another_echonest_ruby_api/request'
  autoload :Response, 'another_echonest_ruby_api/response'

  class ConfigException < Exception
    EXCEPTION_TEXT = <<-eos
    You must setup EchoNest before you can use!  Ex:

    EchoNest.setup do |config|
      config.api_key = 'xxxxxxxx'
    end
eos
  end

  def self.config
    if @config
      @config
    else
      raise ConfigException, ConfigException::EXCEPTION_TEXT
    end
  end

  def self.setup(&block)
    @config = Config.new
    yield @config
  end
end
