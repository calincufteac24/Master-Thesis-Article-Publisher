class ChangeNameOfColumnsAgain < ActiveRecord::Migration[6.1]
  def change
    rename_column :user_personal_informations, :personal_number_chipertext, :personal_number_ciphertext
    rename_column :user_personal_informations, :passport_number_chipertext, :passport_number_ciphertext
  end
end
