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

ActiveRecord::Schema.define(version: 20160903145008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "provider_categories", force: :cascade do |t|
    t.string   "titulo",      null: false
    t.string   "imagen"
    t.text     "descripcion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "provider_categories", ["titulo"], name: "index_provider_categories_on_titulo", unique: true, using: :btree

  create_table "provider_clients", force: :cascade do |t|
    t.integer  "provider_profile_id"
    t.text     "notas"
    t.string   "ruc"
    t.string   "nombres"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "email"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "provider_clients", ["provider_profile_id"], name: "index_provider_clients_on_provider_profile_id", using: :btree

  create_table "provider_item_images", force: :cascade do |t|
    t.integer  "provider_item_id", null: false
    t.string   "imagen",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "provider_item_images", ["provider_item_id"], name: "index_provider_item_images_on_provider_item_id", using: :btree

  create_table "provider_items", force: :cascade do |t|
    t.integer  "provider_profile_id"
    t.string   "titulo",                              null: false
    t.text     "descripcion"
    t.integer  "unidad_medida"
    t.integer  "precio_cents",        default: 0,     null: false
    t.string   "precio_currency",     default: "USD", null: false
    t.string   "volumen"
    t.string   "peso"
    t.text     "observaciones"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "provider_items", ["provider_profile_id"], name: "index_provider_items_on_provider_profile_id", using: :btree

  create_table "provider_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "ruc"
    t.string   "razon_social"
    t.string   "actividad_economica"
    t.string   "tipo_contribuyente"
    t.string   "representante_legal"
    t.string   "telefono"
    t.string   "email"
    t.date     "fecha_inicio_actividad"
    t.string   "banco_nombre"
    t.string   "banco_numero_cuenta"
    t.string   "banco_identificacion"
    t.string   "website"
    t.string   "facebook_handle"
    t.string   "twitter_handle"
    t.string   "instagram_handle"
    t.string   "youtube_handle"
    t.text     "mejor_articulo"
    t.text     "formas_de_pago",         default: [],              array: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "provider_category_id"
  end

  add_index "provider_profiles", ["provider_category_id"], name: "index_provider_profiles_on_provider_category_id", using: :btree
  add_index "provider_profiles", ["user_id"], name: "index_provider_profiles_on_user_id", using: :btree

  create_table "user_locations", force: :cascade do |t|
    t.string   "lat",        null: false
    t.string   "lon",        null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
  end

  add_index "user_locations", ["user_id"], name: "index_user_locations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "info"
    t.json     "credentials"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "provider_clients", "provider_profiles"
  add_foreign_key "provider_item_images", "provider_items"
  add_foreign_key "provider_items", "provider_profiles"
  add_foreign_key "provider_profiles", "provider_categories"
  add_foreign_key "provider_profiles", "users"
  add_foreign_key "user_locations", "users"
end
