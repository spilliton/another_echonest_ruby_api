$:.unshift '.';require File.dirname(__FILE__) + '/helper'

module EchoNest
  class RequestTest < Test::Unit::TestCase

    context 'with credentials' do
      setup do
        setup_test_credentials
      end

      should 'raise if errors in response' do
        mock(:bad_credentials, "artist/profile?api_key=fart&format=json&id=ARZGTK71187B9AC7F5", 400)
        ex = assert_raise(RequestException) do 
          Request.get("artist/profile", id: "ARZGTK71187B9AC7F5")
        end
        assert ex.message =~ /Invalid key: Unknown/i
      end

      should 'correctly build_url' do
        request = Request.new("artist/profile", blah: 'huh', id: 'meh')
        assert_equal 'http://developer.echonest.com/api/v4/artist/profile?api_key=fart&format=json&blah=huh&id=meh', request.build_url
      end

      should 'correctly build url with single bucket params' do 
        request = Request.new("artist/profile", id: 'meh', bucket: 'biographies')
        assert_equal 'http://developer.echonest.com/api/v4/artist/profile?api_key=fart&format=json&id=meh&bucket=biographies', request.build_url
        request = Request.new("artist/profile", id: 'meh', bucket: %w(biographies songs id:spotify-WW))
        assert_equal 'http://developer.echonest.com/api/v4/artist/profile?api_key=fart&format=json&id=meh&bucket=biographies&bucket=songs&bucket=id:spotify-WW', request.build_url
      end

    end

  end
end