class ChangeFormatColumnOfAdTypeField < ActiveRecord::Migration[6.1]
  def change
    rename_column :ad_type_fields, :format, :form_field_type
  end
end
