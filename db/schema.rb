# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150330032454) do

  create_table "cards", force: :cascade do |t|
    t.string   "suit",         limit: 255
    t.string   "name",         limit: 255
    t.string   "abbreviation", limit: 255
    t.integer  "rank",         limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "cards_games", id: false, force: :cascade do |t|
    t.integer "card_id", limit: 4
    t.integer "game_id", limit: 4
  end

  add_index "cards_games", ["card_id"], name: "index_cards_games_on_card_id", using: :btree
  add_index "cards_games", ["game_id"], name: "index_cards_games_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "turn",        limit: 4
    t.integer  "num_players", limit: 4
    t.boolean  "completed",   limit: 1
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "lineups", force: :cascade do |t|
    t.integer  "game_id",     limit: 4
    t.integer  "player_id",   limit: 4
    t.integer  "seat_number", limit: 4
    t.integer  "amount_paid", limit: 4, default: 0
    t.boolean  "won_pot",     limit: 1, default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "lineups", ["game_id"], name: "index_lineups_on_game_id", using: :btree
  add_index "lineups", ["player_id"], name: "index_lineups_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "first_name",  limit: 255
    t.string   "last_name",   limit: 255
    t.string   "email",       limit: 255
    t.string   "password",    limit: 255
    t.string   "screen_name", limit: 255
    t.boolean  "human",       limit: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
