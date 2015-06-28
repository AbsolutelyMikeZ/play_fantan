class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
    @stats = leaderboard(params[:sort], params[:order], params[:page])
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @stats = Lineup.find_by_sql(
                "SELECT COUNT(*) as games_played, 
                        SUM(won_pot::int) as wins, 
                        AVG(won_pot::int) as win_pct, 
                        SUM(amount_paid) as profit, 
                        AVG(amount_paid) as ppg 
                 FROM lineups 
                 WHERE player_id = #{@player.id}"
                 ).first
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end
    
    def leaderboard(sort_col, sort_order, page)
      page = page.to_i

      sql = "SELECT players.screen_name, 
                    COUNT(*) as games_played, 
                    SUM(lineups.won_pot::int) as wins, 
                    AVG(lineups.won_pot::int) as win_pct, 
                    SUM(lineups.amount_paid) as profit, 
                    AVG(lineups.amount_paid) as ppg 
             FROM lineups 
             INNER JOIN players ON lineups.player_id = players.id 
             GROUP BY players.screen_name
            "
      col_map = {
        'Screen Name' => 'players.screen_name',
        'Games Played' => 'games_played',
        'Won (%)' => 'wins',
        'Profit' => 'profit',
        'Profit/Game' => 'ppg'
      }
      
      order_by = col_map.key?(sort_col) ? col_map[sort_col] : 'ppg DESC'       
             
      sql += " ORDER BY " + order_by
      
      if ["asc", "desc"].include?(sort_order)
        sql += ' ' + sort_order
      end
      
      offset = page > 0 ? (page - 1) * 20 : 0
      sql += " LIMIT 20 OFFSET #{offset}"
      
      Lineup.find_by_sql(sql)
    end
    
end
