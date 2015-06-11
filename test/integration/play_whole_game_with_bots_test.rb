require 'test_helper'

class PlayWholeGameWithBotsTest < ActionDispatch::IntegrationTest
  
  def setup
    log_in_as(players(:geno))
  end

  test "run entire game with bots to test a lot" do
    post games_path, game: { completed: false, num_players: 3, turn: 1 }
    @game = Game.last
    assert @game.completed == true
  end
end
