class RemoveUidFullNameUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :uid, :string
    remove_column :users, :full_name, :string
  end
end
