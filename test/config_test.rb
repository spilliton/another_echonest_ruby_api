require 'helper'

class ConfigTest < Test::Unit::TestCase

  should 'raise exception if not configured' do
    assert_raise EchoNest::ConfigException do
      EchoNest::Request.get(:artist => 'sdf')
    end
  end

end
