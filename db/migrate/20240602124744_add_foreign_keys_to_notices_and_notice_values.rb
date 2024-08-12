class AddForeignKeysToNoticesAndNoticeValues < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :notices, :ad_types, column: :ad_type_id
    add_foreign_key :notices, :ad_type_stages, column: :ad_type_stage_id
  end
end
