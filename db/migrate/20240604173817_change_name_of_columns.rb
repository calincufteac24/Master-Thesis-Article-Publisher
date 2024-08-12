class ChangeNameOfColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_personal_informations, :personal_series, :personal_series_ciphertext
    rename_column :user_personal_informations, :personal_number, :personal_number_chipertext
    rename_column :user_personal_informations, :passport_number, :passport_number_chipertext
  end
end
