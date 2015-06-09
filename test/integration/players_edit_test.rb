require 'test_helper'

class PlayersEditTest < ActionDispatch::IntegrationTest

  def setup
    @player = players(:sid)
    @player2 = players(:geno)
    log_in_as(@player)
  end
  
  test "unsuccessful profile edit" do
    get edit_player_path(@player)
    assert_template 'players/edit'
    patch player_path(@player), player: { first_name: " ",
                                        last_name: "Crosby",
                                        email: "blahblah",
                                        password: "longenough",
                                        screen_name: "Sidthekid" }
    assert_template 'players/edit'
  end
  
  test "successful profile edit" do
    get edit_player_path(@player)
    assert_template 'players/edit'
    email = "sid@penguins.com"
    screen_name = "number87"
    patch player_path(@player), player: { first_name: "Sidney", 
                                          last_name: "Crosby", 
                                          email: email,
                                          password: 'password',
                                          screen_name: screen_name }
    assert_not flash.empty?
    assert_redirected_to @player
    @player.reload
    assert_equal email, @player.email
    assert_equal screen_name, @player.screen_name
  end
  
  test "attempted edit without being logged in" do
    delete logout_path
    get edit_player_path(@player)
    assert_redirected_to login_url
    assert_not flash.empty?
  end
  
  test "attempted edit of another player's profile" do
    get edit_player_path(@player2)
    assert_redirected_to players_path
  end
  
  test "attempted update without being logged in" do
    delete logout_path
    patch player_path(@player), player: { first_name: @player.first_name,
                                          last_name: @player.last_name,
                                          email: @player.email,
                                          password: 'password',
                                          screen_name: 'newscreenname' }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "attempted update of another player's profile" do
    patch player_path(@player2), player: { first_name: @player2.first_name,
                                          last_name: @player2.last_name,
                                          email: @player2.email,
                                          password: 'password',
                                          screen_name: 'newscreenname2' }
    assert flash.empty?
    assert_redirected_to players_path
  end
  
end
