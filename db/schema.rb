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

ActiveRecord::Schema.define(version: 20150506053750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "edbspl"
  enable_extension "plpgsql"
  enable_extension "edb_dblink_libpq"
  enable_extension "edb_dblink_oci"
  enable_extension "pldbgapi"

  create_table "cards", force: :cascade do |t|
    t.string   "suit",         limit: 255
    t.string   "name",         limit: 255
    t.string   "abbreviation", limit: 255
    t.integer  "rank"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "cards_games", id: false, force: :cascade do |t|
    t.integer "card_id"
    t.integer "game_id"
  end

  add_index "cards_games", ["card_id"], name: "index_cards_games_on_card_id", using: :btree
  add_index "cards_games", ["game_id"], name: "index_cards_games_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "turn",        default: 1
    t.integer  "num_players"
    t.boolean  "completed",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "dealer",      default: 1
  end

  create_table "hands", force: :cascade do |t|
    t.integer  "lineup_id"
    t.integer  "card_id"
    t.boolean  "viable_play", default: false
    t.integer  "ai_rank"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "hands", ["card_id"], name: "index_hands_on_card_id", using: :btree
  add_index "hands", ["lineup_id"], name: "index_hands_on_lineup_id", using: :btree

  create_table "lineups", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "seat_number"
    t.integer  "amount_paid",             default: 0
    t.boolean  "won_pot",                 default: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "last_action", limit: 255, default: "Nothing yet"
  end

  add_index "lineups", ["game_id"], name: "index_lineups_on_game_id", using: :btree
  add_index "lineups", ["player_id"], name: "index_lineups_on_player_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "first_name",      limit: 255
    t.string   "last_name",       limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.string   "screen_name",     limit: 255
    t.boolean  "human",                       default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "remember_digest", limit: 255
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true, using: :btree
  add_index "players", ["screen_name"], name: "index_players_on_screen_name", unique: true, using: :btree

end
