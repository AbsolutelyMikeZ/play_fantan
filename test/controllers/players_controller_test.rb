require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:sid)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
    assert_not_nil assigns(:stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

# Create controller tested in Players Signup integration test

  test "should show player" do
    get :show, id: @player
    assert_response :success
  end

# Edit and Update controllers tested in Players Edit integration test

  test "should destroy player" do
    log_in_as(@player)
    assert_difference('Player.count', -1) do
      delete :destroy, id: @player
    end

    assert_redirected_to players_path
  end
end
