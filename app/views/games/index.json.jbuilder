json.array!(@games) do |game|
  json.extract! game, :id, :turn, :num_players, :completed
  json.url game_url(game, format: :json)
end
