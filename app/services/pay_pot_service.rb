class PayPotService
  def initialize(lineup_id)
    @lineup_id = lineup_id
  end
  
  def pay_the_pot
    @payee = Lineup.find(@lineup_id)
    @payee.amount_paid -= 1
    @payee.last_action = "Paid"
    @payee.save
    
    advance = AdvanceTurnService.new(@payee.game_id).advance_turn
    return true
  end
  
end