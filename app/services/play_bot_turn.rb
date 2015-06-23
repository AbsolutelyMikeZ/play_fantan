class PlayBotTurn
  
# calculates "score" if multiple viable plays in the bot hand
# lowest "score" is the hand(card) to be played, thus most likely to help the bot player
# a "gap" may be calculated.  gap == 1 means the adjacent card, gap == 2 means there is one card missing between, etc
# score = 10 - 16 for cards that build towards other cards in the hand, with 10 = largest gap
# score = 20 if player has adjacent card and thus can't help other players
# score = 30 if card is an Ace or King (thus can't help anyone else)
# score = 30 - 36 for cards that don't help the player, and only could help other players  
# 37 is highest score, for a 7 with no other cards in the suit. Strategy: hold this 7 until last possible turn  
  
  def initialize(game_id)
    @game_id = game_id
  end
  
  def play_turn
    @game = Game.find(@game_id)
    
    # Count viable plays
    bot_lineup = Lineup.includes(:hands, :cards).where("lineups.game_id = #{@game_id}").where("lineups.seat_number = #{@game.turn}").first
    count = 0
    bot_lineup.hands.each do |h|
      h.viable_play ? count += 1 : count += 0
    end
    
    # If none, pay the pot
    if count == 0
      pay_it_bitch = PayPotService.new(bot_lineup.id.to_i).pay_the_pot
    end
    
    # If one, play it
    if count == 1
      hand_to_play = bot_lineup.hands.select { |x| x.viable_play == true }.first
      play_card = PlayCardService.new(hand_to_play.id, @game_id).play_the_card
    end
    
    # If multiple, calculate AI rank for each then choose by lowest AI rank
    if count > 1
      possible_plays = bot_lineup.hands.select { |x| x.viable_play == true }
      all_cards = bot_lineup.cards.to_a
      lowest_ai_score = 100
      best_hand_id = nil
      
      possible_plays.each { |pp|
        gaps = []  # Reset gaps array for each pp
        if pp.card.rank == 7
          if all_cards.count { |y| y.suit == pp.card.suit } > 1
            temp_value = 7
            all_cards.select { |z| z.suit == pp.card.suit && z.rank > pp.card.rank }
                .sort_by { |s| [s.rank] }
                .each { |e| 
                  gaps << e.rank - temp_value
                  temp_value = e.rank
                 }
            temp_value = 7
            all_cards.select { |z| z.suit == pp.card.suit && z.rank < pp.card.rank }
                .sort_by { |s| [s.rank] }
                .reverse
                .each { |e|
                  gaps << temp_value - e.rank 
                  temp_value = e.rank
                }
            max_gap = gaps.sort.fetch(-1)
            if max_gap == 1
              if all_cards.count { |y| y.suit == pp.card.suit && y.rank < 7 } > 0 && all_cards.count { |y| y.suit == pp.card.suit && y.rank > 7 } > 0
                score = 20
              else
                score = 36
              end
            else
              score = 16 - max_gap  
            end
          else
            score = 37
          end
        elsif pp.card.rank > 7 && pp.card.rank < 13
          if all_cards.count { |y| y.suit == pp.card.suit && y.rank > pp.card.rank } > 0
            temp_value = pp.card.rank
            all_cards.select { |z| z.suit == pp.card.suit && z.rank > pp.card.rank }
                     .sort_by { |s| [s.rank] }
                     .each { |e|
                       gaps << e.rank - temp_value
                       temp_value = e.rank 
                     }
            max_gap = gaps.sort.fetch(-1)
            if max_gap == 1
              score = 20
            else
              score = 16 - max_gap
            end
          else
            score = 43 - pp.card.rank
          end
        elsif pp.card.rank < 7 && pp.card.rank > 1
          if all_cards.count { |y| y.suit == pp.card.suit && y.rank < pp.card.rank } > 0
            temp_value = pp.card.rank
            all_cards.select { |z| z.suit == pp.card.suit && z.rank < pp.card.rank }
                     .sort_by { |s| [s.rank] }
                     .reverse
                     .each { |e| 
                       gaps << temp_value - e.rank
                       temp_value = e.rank 
                     }
            max_gap = gaps.sort.fetch(-1)
            if max_gap == 1
              score = 20
            else
              score = 16 - max_gap
            end
          else
            score = 29 + pp.card.rank  
          end 
        else  
          score = 30
        end
        
        # Rails.logger.info "PP Card: #{pp.card.abbreviation}"
        # Rails.logger.info "AI score: #{score}"
        
        if score < lowest_ai_score
          best_hand_id = pp.id
          lowest_ai_score = score
        end
      }
      
      play_card = PlayCardService.new(best_hand_id, @game_id).play_the_card
    end  #ends if count > 1 ai bot logic block
    
  end  #ends play_turn method
  
end  #ends class