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

ActiveRecord::Schema.define(version: 20160128003945) do

  create_table "query_histories", force: :cascade do |t|
    t.datetime "date"
    t.string   "bibnumber"
  end

  create_table "tmdb_records", force: :cascade do |t|
    t.integer  "query_history_id"
    t.string   "poster_url"
    t.string   "imdb_id"
    t.datetime "created_at"
    t.datetime "update_at"
  end

  add_index "tmdb_records", ["query_history_id"], name: "index_tmdb_records_on_query_history_id"

end
