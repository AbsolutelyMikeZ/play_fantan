require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  
  def setup
    @player = Player.new(first_name: 'Mario', last_name: 'Lemieux', email: 'Supermario@penguins.com', screen_name: 'Super Mario', human: true, password: 'aklsdjfal2312')
    @stringtoolong = "a" * 260
  end

  test "should be valid" do
    assert @player.valid?
  end
  
  test "first name should be valid" do
    @player.first_name = " "
    assert_not @player.valid?
    @player.first_name = @stringtoolong
    assert_not @player.valid?
  end

  test "last name should be valid" do
    @player.last_name = " "
    assert_not @player.valid?
    @player.last_name = @stringtoolong
    assert_not @player.valid?
  end
  
  test "email should be valid length and unique" do
    @player.email = " "
    assert_not @player.valid?
    @player.email = @stringtoolong
    assert_not @player.valid?
    @player.email = "Sidthekid@penguins.com"  # match :sid email and test case insensitivity
    assert_not @player.valid?
  end
  
  test "screen name should be valid length and unique" do
    @player.screen_name = "  "
    assert_not @player.valid?
    @player.screen_name = @stringtoolong
    assert_not @player.valid?
    @player.screen_name = "Sidthekid"  # match :sid screen_name and test case insensitivity
    assert_not @player.valid?
  end
  
  test "password should be valid length and non-blank" do
    @player.password = "12345"
    assert_not @player.valid?
    @player.password = "         "
    assert_not @player.valid?
  end
  
  test "email addresses stored in lowercase" do
    @player.save
    assert_equal @player.email, "supermario@penguins.com" 
  end
  
  
end
