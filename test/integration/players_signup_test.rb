require 'test_helper'

class PlayersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup submission" do
    get new_player_path
    assert_no_difference 'Player.count' do
      post players_path, player: { first_name: "",
                                   last_name: "",
                                   email: "blah@blah.com",
                                   screen_name: "blahblah",
                                   password: "short",
                                   human: true }
    end
    assert_template 'players/new'
  end
  
  test "valid signup submission" do
    get new_player_path
    assert_difference 'Player.count', 1 do
      post_via_redirect players_path, player: { first_name: "Kris",
                                                last_name: "Letang",
                                                email: "kl@penguins.com",
                                                screen_name: "topDman",
                                                password: "aksldjflwk",
                                                human: true }
    end
    assert_template 'players/show'
  end

end
