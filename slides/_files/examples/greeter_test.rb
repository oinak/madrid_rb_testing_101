require 'minitest/autorun' # to test a single file
require 'greeter' # test subject

class GreeterTest < Minitest::Test
  def test_say
    greeter = Greeter.new("Ada")

    assert_equal(greeter.say, "Hello Ada!")
  end
end
