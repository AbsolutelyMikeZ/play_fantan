class UpdateViablePlays
  
  def initialize(game_id, suit, rank)
    @game_id = game_id
    @suit = suit
    @rank = rank
  end
  
  def update_viable
    # if rank = 7 and suit = diamonds, update the other sevens
    if @rank == 7 && @suit == "Diamonds"
      Hand.joins(:card)
          .joins(:lineup)
          .where("cards.rank = 7")
          .where("lineups.game_id = #{@game_id}")
          .update_all(:viable_play => true)
    end
    
    # if rank < 8 and > 1, update_down
    if @rank < 8 && @rank > 1
      Hand.joins(:card)
          .joins(:lineup)
          .where("cards.rank = #{@rank - 1}")
          .where("cards.suit = '#{@suit}'")
          .where("lineups.game_id = #{@game_id}")
          .update_all(:viable_play => true)
    end
    
    # if rank > 6 and < 13, update_up
    if @rank > 6 && @rank < 13
      Hand.joins(:card)
          .joins(:lineup)
          .where("cards.rank = #{@rank + 1}")
          .where("cards.suit = '#{@suit}'")
          .where("lineups.game_id = #{@game_id}")
          .update_all(:viable_play => true)
    end
  end
end