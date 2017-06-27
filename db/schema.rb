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

ActiveRecord::Schema.define(version: 20170627203113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champion_performances", force: :cascade do |t|
    t.integer "champion_id"
    t.string "role"
    t.decimal "win_rate"
    t.decimal "ban_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "champions", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "final_item_usages", force: :cascade do |t|
    t.integer "champion_performance_id"
    t.integer "item_id"
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
  end

  create_table "initial_item_usages", force: :cascade do |t|
    t.integer "champion_performance_id"
    t.integer "item_id"
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "plain_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "color"
    t.integer "tier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summoner_spells", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
