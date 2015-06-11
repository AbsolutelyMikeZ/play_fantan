require 'test_helper'

class PlayCardServiceTest < ActionDispatch::IntegrationTest
  
  def setup
    @player = players(:sid)
    log_in_as(@player)
    @lineup = lineups(:one)
    @game = games(:one)
  end
  
  # test playing invalid play
  test "invalid play should redirect back to game" do
    @hand = hands(:thirtyfour)
    assert_no_difference ['@lineup.hands.count', '@game.turn'] do
      patch play_card_game_path(@game), hand_id: @hand.id
    end
    assert_redirected_to game_path(@game)   
  end
  
  # test playing when not turn
  test "play valid card but out of turn should redirect back to game" do
    @lineup = lineups(:two)
    @hand = hands(:nine)
    assert_no_difference ['@lineup.hands.count', '@game.turn'] do
      patch play_card_game_path(@game), hand_id: @hand.id
    end
    assert_redirected_to game_path(@game) 
  end
  
  # test playing valid play on turn
  test "play valid card should remove card from hand, place on board, and turns advance" do
    cards_played = @game.cards.count
    assert_difference '@lineup.hands.count', -1 do
      patch play_card_game_path(@game), hand_id: hands(:thirtyseven).id
    end
    assert @game.cards.count - cards_played > 2
    
  end
  
  # test playing card no longer in hand
  test "play a card that no longer exists in hand should redirect back to game" do
    assert_no_difference ['@lineup.hands.count', '@game.turn'] do
      patch play_card_game_path(@game), hand_id: 0
    end
    assert_redirected_to game_path(@game)
  end
end
