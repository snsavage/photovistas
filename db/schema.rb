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

ActiveRecord::Schema.define(version: 20161208132016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photo_queues", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photo_id"], name: "index_photo_queues_on_photo_id", using: :btree
    t.index ["user_id"], name: "index_photo_queues_on_user_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "unsplash_id"
    t.string   "thumb_url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "width"
    t.integer  "height"
    t.string   "photographer_name"
    t.string   "photographer_link"
    t.string   "raw_url"
    t.string   "full_url"
    t.string   "regular_url"
    t.string   "small_url"
    t.string   "link"
    t.index ["unsplash_id"], name: "index_photos_on_unsplash_id", using: :btree
  end

  create_table "test", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "index"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "unsplash_username"
    t.text     "unsplash_token"
  end

end
