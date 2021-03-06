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

ActiveRecord::Schema.define(version: 20140209081608) do

  create_table "apis", force: true do |t|
    t.integer "lat",                   null: false
    t.integer "lon",                   null: false
    t.string  "place_name", limit: 32
    t.integer "prc"
    t.integer "sst"
    t.integer "ssw"
    t.integer "smc"
    t.integer "snd"
    t.date    "date",                  null: false
  end

  add_index "apis", ["lat", "lon"], name: "index_apis_on_lat_and_lon", using: :btree

  create_table "places", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
