module EchoNest
  class Query

    def self.search(params)
      response = Request.get(params)
      response.results
    end

  end
end