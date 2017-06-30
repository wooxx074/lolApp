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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20170726201200) do

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
=======
ActiveRecord::Schema.define(version: 20170630211332) do

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
>>>>>>> Added new/edit/views to team and leagues, WIP
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "matches", force: :cascade do |t|
<<<<<<< HEAD
    t.integer  "game_id",      limit: 8
    t.text     "match_info"
    t.text     "pros_in_game",           default: "--- []\n"
    t.text     "text",                   default: "--- []\n"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.text     "summonername"
    t.string   "role"
    t.string   "twitchtv"
    t.string   "twitter"
    t.datetime "last_regenerated_matches"
    t.string   "slug"
    t.integer  "team_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
=======
    t.integer  "match_id"
    t.text     "match_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "summonername"
    t.string   "role"
    t.string   "twitchtv"
    t.integer  "team_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
>>>>>>> Added new/edit/views to team and leagues, WIP
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "league_id"
    t.string   "name"
<<<<<<< HEAD
    t.string   "slug"
=======
>>>>>>> Added new/edit/views to team and leagues, WIP
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["league_id"], name: "index_teams_on_league_id"
  end

end
