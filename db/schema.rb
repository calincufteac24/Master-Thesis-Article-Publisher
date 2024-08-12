# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_06_16_152823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ad_type_fields", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ad_type_id", null: false
    t.integer "form_field_type", null: false
    t.text "help_text"
    t.text "text_before"
    t.text "text_after"
    t.boolean "required", default: false, null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "option_values", default: [], array: true
  end

  create_table "ad_type_stages", force: :cascade do |t|
    t.integer "ad_type_id", null: false
    t.integer "stage_id", null: false
    t.integer "position", null: false
    t.boolean "create_invoice", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ad_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "about"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "category_id", null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "about"
    t.boolean "is_primary", default: false
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "notice_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notice_id"], name: "index_comments_on_notice_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ocr_remote_file_path"
    t.text "ocr_text"
  end

  create_table "notice_values", force: :cascade do |t|
    t.bigint "notice_id"
    t.bigint "ad_type_field_id"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ad_type_field_id"], name: "index_notice_values_on_ad_type_field_id"
    t.index ["notice_id"], name: "index_notice_values_on_notice_id"
  end

  create_table "notices", force: :cascade do |t|
    t.bigint "ad_type_id"
    t.bigint "ad_type_stage_id"
    t.bigint "creator_id"
    t.bigint "assigned_to_id"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "observation"
    t.text "options"
    t.string "invoiceable_type"
    t.bigint "invoiceable_id"
    t.boolean "payment_required", default: false
    t.boolean "payment_successful"
    t.decimal "price", precision: 10, scale: 2
    t.index ["ad_type_id"], name: "index_notices_on_ad_type_id"
    t.index ["ad_type_stage_id"], name: "index_notices_on_ad_type_stage_id"
    t.index ["assigned_to_id"], name: "index_notices_on_assigned_to_id"
    t.index ["creator_id"], name: "index_notices_on_creator_id"
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_notices_on_invoiceable"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "fiscal_code", null: false
    t.string "reg_com", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "contract_number"
    t.index ["fiscal_code"], name: "index_organizations_on_fiscal_code", unique: true
    t.index ["role"], name: "index_organizations_on_role"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rating"
    t.bigint "notice_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notice_id"], name: "index_ratings_on_notice_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "about"
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_organizations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.string "job_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "permission", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "user_personal_informations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "personal_series_ciphertext", limit: 255
    t.string "personal_number_ciphertext", limit: 255
    t.string "passport_number_ciphertext", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_personal_informations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "status", default: 0
    t.string "avatar_url"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ad_type_fields", "ad_types"
  add_foreign_key "ad_type_stages", "ad_types"
  add_foreign_key "ad_type_stages", "stages"
  add_foreign_key "comments", "notices"
  add_foreign_key "comments", "users"
  add_foreign_key "notice_values", "ad_type_fields"
  add_foreign_key "notice_values", "notices"
  add_foreign_key "notices", "ad_type_stages"
  add_foreign_key "notices", "ad_types"
  add_foreign_key "notices", "users", column: "assigned_to_id"
  add_foreign_key "notices", "users", column: "creator_id"
  add_foreign_key "ratings", "notices"
  add_foreign_key "ratings", "users"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_personal_informations", "users"

  create_view "views_average_ratings_of_notices", sql_definition: <<-SQL
      SELECT ad_types.name AS ad_type_name,
      avg(ratings.rating) AS average_rating,
      count(ratings.rating) AS rating_count,
      max(notices.created_at) AS ad_type_created_at
     FROM ((notices
       LEFT JOIN ratings ON ((ratings.notice_id = notices.id)))
       JOIN ad_types ON ((ad_types.id = notices.ad_type_id)))
    GROUP BY ad_types.name;
  SQL
  create_view "views_notices_by_dates", materialized: true, sql_definition: <<-SQL
      SELECT notices.id AS notice_id,
      notice_values.value AS date_value
     FROM ((notices
       JOIN notice_values ON ((notice_values.notice_id = notices.id)))
       JOIN ad_type_fields ON ((ad_type_fields.id = notice_values.ad_type_field_id)))
    WHERE (ad_type_fields.form_field_type = 1)
    ORDER BY (to_date(notice_values.value, 'DD-MM-YYYY'::text)) DESC NULLS LAST;
  SQL
  create_view "views_search_notices", materialized: true, sql_definition: <<-SQL
      SELECT n.id AS notice_id,
      n.observation,
      atrt.body AS description,
      nv.value AS title
     FROM (((notices n
       LEFT JOIN action_text_rich_texts atrt ON (((atrt.record_id = n.id) AND ((atrt.record_type)::text = 'Notice'::text) AND ((atrt.name)::text = 'description'::text))))
       LEFT JOIN ad_type_fields atf ON (((atf.name)::text = 'Titlu'::text)))
       LEFT JOIN notice_values nv ON (((nv.notice_id = n.id) AND (nv.ad_type_field_id = atf.id))));
  SQL
  create_view "views_price_earnings", sql_definition: <<-SQL
      SELECT c.name AS category_name,
      nv.value AS notice_title,
      n.price,
      n.created_at
     FROM ((((notices n
       JOIN ad_types a ON ((n.ad_type_id = a.id)))
       JOIN categories c ON ((a.category_id = c.id)))
       JOIN notice_values nv ON ((n.id = nv.notice_id)))
       JOIN ad_type_fields atf ON ((nv.ad_type_field_id = atf.id)))
    WHERE ((n.price <> 0.00) AND ((atf.name)::text = 'Titlu'::text))
    ORDER BY c.name;
  SQL
end
