# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

suits = ["Clubs", "Diamonds", "Hearts", "Spades"]
names = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
abbreviations = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

suits.each do |s|
  suit_abbrev = s[0,1].downcase
  13.times do |i|
    rank = i + 1
    abbrev = abbreviations[i] + suit_abbrev
    Card.create!(suit: s, name: names[i], abbreviation: abbrev, rank: rank)
  end
end


robot_names = ["Bender", "KITT", "Johnny 5", "HAL 9000", "Wall-E", "R2D2"]

robot_names.each do |r|
  player = Player.new(first_name: "A.I.", last_name: "Robot", screen_name: r, human: false, email: r)
  player.save(:validate => false)
end
