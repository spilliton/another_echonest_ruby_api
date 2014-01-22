require 'rest_client'

module EchoNest

  class RequestException < Exception; end

  class Request

    BASE_URL = "http://developer.echonest.com/api/v4/"

    attr_reader :params, :path, :bucket_params

    def initialize(path, opts={})
      @path = path
      @params = opts
      @bucket_params = if bucket = opts.delete(:bucket)
        bucket.is_a?(Array) ? bucket : [bucket]
      else
        []
      end
    end

    def self.get(path, opts={})
      request = Request.new(path, opts)
      request.get_response
    end

    def get_response
      response = RestClient.get(build_url) do |response, request, result, &block|
        # puts "response.code: #{response.code.inspect}"
        # puts "response.body: #{response.body.inspect}"
        if [200, 400].include? response.code
          build_response(response.body)
        else
          raise RequestException, "Unexpected response code: #{response.code}"
        end
      end

      if response.error?
        raise RequestException, "The following errors were returned: #{response.message.inspect}"
      else
        response
      end
    end

    def build_response(data)
      Response.new(:raw_json => data.to_str, :request => self)
    end

    def build_params
      {param_name => params}
    end

    def build_url
      url = url_with_creds
      if params.any?
        parts = []
        params.each_pair do |name, value|
          parts << "#{URI.escape(name.to_s)}=#{URI.escape(value.to_s)}"
        end
        bucket_params.each do |value|
          parts << "bucket=#{value}"
        end
        url = "#{url}&#{parts.join('&')}"
      end
      # puts "url: #{url.inspect}"
      url
    end

    def api_key
      EchoNest.config.api_key
    end

    def url_with_creds
      "#{BASE_URL}#{path}?api_key=#{api_key}&format=json"
    end

  end
end