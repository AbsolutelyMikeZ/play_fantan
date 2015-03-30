json.array!(@cards) do |card|
  json.extract! card, :id, :suit, :name, :abbreviation, :rank
  json.url card_url(card, format: :json)
end
