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

ActiveRecord::Schema.define(version: 20160622231200) do

  create_table "events", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.integer  "venue_id",              limit: 4
    t.integer  "parent_event_id",       limit: 4
    t.integer  "locality_id",           limit: 4
    t.string   "title",                 limit: 255
    t.text     "description",           limit: 65535
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "address1",              limit: 255
    t.string   "address2",              limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zipcode",               limit: 255
    t.string   "country",               limit: 255
    t.string   "link_url",              limit: 255
    t.string   "image_url",             limit: 255
    t.decimal  "latitude",                            precision: 10, scale: 7
    t.decimal  "longitude",                           precision: 10, scale: 7
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "ticketmaster_event_id", limit: 255
  end

  create_table "venues", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "headline",           limit: 255
    t.text     "description",        limit: 65535
    t.text     "comments",           limit: 65535
    t.string   "owner_type",         limit: 255
    t.string   "phone",              limit: 255
    t.string   "county",             limit: 255
    t.string   "district",           limit: 255
    t.string   "locality",           limit: 255
    t.string   "address1",           limit: 255
    t.string   "address2",           limit: 255
    t.string   "city",               limit: 255
    t.string   "state",              limit: 255
    t.decimal  "latitude",                         precision: 10
    t.decimal  "longitude",                        precision: 10
    t.string   "latitude_str",       limit: 255
    t.string   "longitude_str",      limit: 255
    t.string   "url",                limit: 255
    t.string   "wiki_url",           limit: 255
    t.string   "logo_url",           limit: 255
    t.text     "summary",            limit: 65535
    t.text     "attractions",        limit: 65535
    t.text     "photo_urls",         limit: 65535
    t.string   "opening_date",       limit: 255
    t.string   "number_of_rooms",    limit: 255
    t.string   "theme",              limit: 255
    t.string   "total_gaming_space", limit: 255
    t.string   "permanent_space",    limit: 255
    t.string   "casino_type",        limit: 255
    t.string   "owner",              limit: 255
    t.datetime "renovated_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

end
