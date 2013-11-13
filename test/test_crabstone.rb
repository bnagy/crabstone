gem 'test-unit'
require 'test/unit'
require 'crabstone'

class TC_Crabstone < Test::Unit::TestCase
  test "version number is set to expected value" do
    assert_equal('0.0.1', Crabstone::VERSION)
  end
end
