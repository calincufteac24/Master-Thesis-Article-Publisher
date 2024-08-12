class UserPersonalInformationLimit < ActiveRecord::Migration[6.1]
  def change
    change_column :user_personal_informations, :personal_series, :string, limit: 255
    change_column :user_personal_informations, :personal_number, :string, limit: 255
    change_column :user_personal_informations, :passport_number, :string, limit: 255
  end
end
