class AddContractNumberToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :contract_number, :string
    add_column :users, :county, :string
    add_column :users, :job_title, :string
  end
end
