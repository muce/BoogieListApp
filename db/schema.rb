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

ActiveRecord::Schema.define(version: 20140204123842) do

  create_table "imports", force: true do |t|
    t.integer  "limit"
    t.string   "until"
    t.string   "paging_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
  end

  create_table "playlist_posts", force: true do |t|
    t.integer  "playlist_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlist_songs", force: true do |t|
    t.integer  "playlist_id"
    t.integer  "song_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.string   "description"
    t.string   "link_url"
    t.string   "source_url"
    t.string   "message"
    t.integer  "likes"
    t.integer  "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_url"
    t.string   "artist"
    t.string   "title"
    t.datetime "post_date"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "songs", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "youtube_url"
    t.string   "mp3_url"
    t.string   "picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
