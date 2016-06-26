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

ActiveRecord::Schema.define(version: 20160626154238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "figures", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "color"
    t.string   "type"
    t.string   "cell_name"
    t.string   "beaten_fields",    default: [],              array: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "server_figure_id"
  end

  add_index "figures", ["game_id"], name: "index_figures_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.integer  "server_game_id"
    t.boolean  "white_turn",     default: true
    t.float    "game_result"
    t.integer  "offer_draw_by"
    t.string   "possibles",      default: [],                 array: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "white_side",     default: true
    t.integer  "user_id"
    t.boolean  "checked",        default: false
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email",      default: ""
    t.string   "password",   default: ""
    t.integer  "power",      default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "token",      default: ""
    t.integer  "elo",        default: 0
  end

end
