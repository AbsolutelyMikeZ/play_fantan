require 'test_helper'

class UrlForwardingTest < ActionDispatch::IntegrationTest

  def setup
    @player = Player.first
  end
  
  test "edit profile forwarding" do
    get edit_player_path(@player)
    log_in_as(@player)
    assert_redirected_to edit_player_path(@player)
  end
  
  test "new game forwarding" do
    get new_game_path
    log_in_as(@player)
    assert_redirected_to new_game_path
  end
end
