require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  setup do
    @game = games(:one)
    @player = players(:sid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_redirected_to login_url
    assert_not flash.empty?
    # Must be logged in to create
    log_in_as(@player)
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_no_difference('Game.count') do
      post :create, game: { completed: false, num_players: 3, turn: 1 }
    end
    assert_redirected_to login_url
    assert_not flash.empty?
    # Must be logged in to create
    log_in_as(@player)
    assert_difference('Game.count') do
      post :create, game: { completed: false, num_players: 3, turn: 1 }
    end

    assert_redirected_to game_path(assigns(:game))
    assert_not flash.empty?
  end
  
  test "create game failure" do
    log_in_as(@player)
    assert_no_difference('Game.count') do
      post :create, game: { completed: false, num_players: 10, turn: 1 }
    end
    assert_template 'games/new'
  end
  
  test "should show game" do
    get :show, id: @game
    assert_response :success
  end

  test "should destroy game" do
    assert_difference('Game.count', -1) do
      delete :destroy, id: @game
    end

    assert_redirected_to games_path
  end
end
