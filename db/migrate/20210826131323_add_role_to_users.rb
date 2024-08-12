class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, null: false

    add_index :users, :role

    User.create!(first_name: 'Andrei', last_name: 'Luca', email: 'andrei.luca@eventya.net', role: :employee,
                 password: 'aluca2007', password_confirmation: 'aluca2007', admin: true, status: :approved) do |u|
      u.accept_terms = true
      u.skip_confirmation!
      u.skip_reconfirmation!
    end
    User.create!(first_name: 'Calin', last_name: 'Cufteac', email: 'calin.cufteac@eventya.net', role: :employee,
                 password: 'ccufteac2007', password_confirmation: 'ccufteac2007', admin: true, status: :approved) do |u|
      u.accept_terms = true
      u.skip_confirmation!
      u.skip_reconfirmation!
    end
  end
end
