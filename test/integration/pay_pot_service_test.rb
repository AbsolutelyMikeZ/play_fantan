require 'test_helper'

class PayPotServiceTest < ActionDispatch::IntegrationTest
  
  def setup
    @game = games(:one)
  end
  
  # test pay with viable plays fails
  test "pay pot when viable play exists redirects back to game" do
    @lineup = lineups(:one)
    assert_difference '@lineup.amount_paid', -1 do
      patch pay_pot_game_path(@game), lineup_id: @lineup.id
    end
    assert_redirected_to game_path(@game)
  end
  
  
  # test pay when not your turn fails
  
  # test pay twice by doubleclicking fails and only pays once
  
  # test pay pot works properly, subtracting 1 in database 
end
