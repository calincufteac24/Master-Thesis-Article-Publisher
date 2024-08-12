class RemoveCountyAndJobTitle < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :county, :string
    remove_column :users, :job_title, :string
  end
end
