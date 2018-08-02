ActiveRecord::Schema.define(version: 2018_08_02_081919) do

  create_table "movie_tickets", force: :cascade do |t|
    t.integer "seat_id"
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_movie_tickets_on_order_id"
    t.index ["seat_id"], name: "index_movie_tickets_on_seat_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.string "cast"
    t.string "director"
    t.text "description"
    t.integer "duration"
    t.integer "rated"
    t.string "language"
    t.string "genre"
    t.date "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_movies_on_title", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "screening_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screening_id"], name: "index_orders_on_screening_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "seat_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "screenings", force: :cascade do |t|
    t.integer "movie_id"
    t.integer "room_id"
    t.datetime "screening_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_screenings_on_movie_id"
    t.index ["room_id"], name: "index_screenings_on_room_id"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "row"
    t.integer "number"
    t.integer "seat_type"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seats_on_room_id"
    t.index ["row", "number"], name: "index_seats_on_row_and_number", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "reset_digest"
    t.string "activation_digest"
    t.integer "user_type"
    t.datetime "activated_at"
    t.integer "activated"
    t.boolean "blocked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end