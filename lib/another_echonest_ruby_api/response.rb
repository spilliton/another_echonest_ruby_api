require 'json'
require 'hashie'

module EchoNest
  class Response

    # data attr is a Hashie::Mash you can use to get at json attributes returned
    # ex:  response.data.artist.name, response.data.artist.name etc
    attr_reader :request, :raw_json, :data, :status

    def initialize(opts={})
      @request = opts[:request]
      @raw_json = opts[:raw_json]
      h = JSON.parse(@raw_json)
      @data = Hashie::Mash.new(h['response'])
      @status = data.status
    end

    def error?
      status.code != 0
    end

    def message
      status.message
    end
    
    def version
      status.version
    end


  end
end