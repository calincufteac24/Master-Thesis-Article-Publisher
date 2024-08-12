class AddOptionValuesForAdTypeFields < ActiveRecord::Migration[6.1]
  def change
    add_column :ad_type_fields, :option_values, :text, array: true, default: []
  end
end
