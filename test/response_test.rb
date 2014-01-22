$:.unshift '.';require File.dirname(__FILE__) + '/helper'

module EchoNest
  class ResponseTest < Test::Unit::TestCase

    should "create a hashie mash of data" do 
      json = '{"response": {"status": {"version": "4.2", "code": 0, "message": "Success"}, "artist": {"id": "ARZGTK71187B9AC7F5", "name": "Eels"}}}'
      response = Response.new(:raw_json => json)
      artist = response.data.artist
      assert_equal 'Eels', artist.name
      assert_equal 'ARZGTK71187B9AC7F5', artist.id
    end

  end
end