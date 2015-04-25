class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_player, only: [:edit, :update, :destroy]
  before_action :correct_player, only: [:edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
    @stats = leaderboard(params[:sort].to_i, params[:order], params[:page].to_i)
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        log_in @player
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:first_name, :last_name, :email, :password, :screen_name, :human)
    end
    
    def logged_in_player
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_player
      redirect_to(players_url) unless current_player?(set_player)
    end
    
    def leaderboard(sort_col, sort_order, page)
      sql = "SELECT players.screen_name, COUNT(*) as games_played, SUM(lineups.won_pot::int) as wins, AVG(lineups.won_pot::int) as win_pct, 
             SUM(lineups.amount_paid) as profit, AVG(lineups.amount_paid) as ppg FROM lineups INNER JOIN players ON lineups.player_id = players.id GROUP BY players.screen_name"
      cols = %w[players.screen_name games_played wins profit ppg]
      if sort_col > 0
        sql += " ORDER BY " + cols[sort_col - 1]
        if sort_order == "asc"
          sql += " ASC"
        elsif sort_order == "desc"
          sql += " DESC"
        end
      else
        sql += " ORDER BY ppg DESC"
      end
      
      if page > 0
        offset = (page - 1) * 20
        sql += " LIMIT 20 OFFSET #{offset}"
      else
        sql += " LIMIT 20 OFFSET 0"
      end
      
      Lineup.find_by_sql(sql)
    end
    
end
