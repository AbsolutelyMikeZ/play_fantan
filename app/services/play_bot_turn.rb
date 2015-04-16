class PlayBotTurn
  
  def initialize(game_id)
    @game_id = game_id
  end
  
  def play_turn
    @game = Game.find(@game_id)
    
    # Count viable plays
    bot_lineup = Lineup.includes(:hands, :cards).where("lineups.game_id = #{@game_id}").where("lineups.seat_number = #{@game.turn}")
    count = 0
    bot_lineup[0].hands.each do |h|
      h.viable_play ? count += 1 : count += 0
    end
    
    # If none, pay the pot
    if count == 0
      pay_it_bitch = PayPotService.new(bot_lineup[0].id.to_i).pay_the_pot
    end
    
    # If one, play it
    if count == 1
      hand_to_play = bot_lineup[0].hands.select { |x| x.viable_play == true }
      play_card = PlayCardService.new(hand_to_play[0].id, @game_id).play_the_card
    end
    
    # If multiple, calculate AI rank for each then choose by lowest AI rank
    if count > 1
      possible_plays = bot_lineup[0].hands.select { |x| x.viable_play == true }
      all_cards = bot_lineup[0].cards.to_a
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