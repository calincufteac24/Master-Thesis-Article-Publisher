class AddCategoryToAdTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :ad_types, :category_id, :integer, null: false, foreign_key: true
  end
end
