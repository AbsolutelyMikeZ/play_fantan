class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_player, only: [:new, :create]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        # Create lineups for the Players in the Game
        players = Player.where("human = false").sample(@game.num_players - 1)
        players << current_player
        players.each_with_index do |player, i|
          lineup = Lineup.create(:game_id => @game.id, :player_id => player.id, :seat_number => i + 1)
        end
        
        # Deal the cards
        deal_em = DealNewGame.new(@game).deal
        
        format.html { redirect_to @game, notice: 'Game on!  Good luck!' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
  


  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  
  def pay_pot
    PayPotService.new(params[:lineup_id]).pay_the_pot
    redirect_to controller: 'games', action: 'show', id: params[:id]
  end
  
  def play_card
    PlayCardService.new(params[:hand_id], params[:id]).play_the_card
    redirect_to controller: 'games', action: 'show', id: params[:id]
  end
  
  def play_for_bot
    PlayBotTurn.new(params[:id]).play_turn
    redirect_to controller: 'games', action: 'show', id: params[:id]
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:turn, :num_players, :completed)
    end
    
    def logged_in_player
      unless logged_in?
        store_location
        flash[:danger] = "Please log in or create an account to start a game."
        redirect_to login_url
      end
    end
    
end
