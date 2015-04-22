require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def setup
    @player = Player.new(first_name: "Jimmy", last_name: "Jimmerson", email: "jimmyj@test.com", screen_name: "JJtheKing")
  end

  test "should be valid" do
    assert @player.valid?
  end
  
  test "first name should be present" do
    @player.first_name = "    "
    assert_not @player.valid?
  end
  
  test "last name should be present" do
    @player.last_name = "  "
    assert_not @player.valid?
  end
  
  test "email should be present" do
    @player.email = "  "
    assert_not @player.valid?
  end
  
  test "screen name should be present" do
    @player.screen_name = "  "
    assert_not @player.valid?
  end
 
end
