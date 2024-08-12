class UpdateNoticeStripe < ActiveRecord::Migration[6.1]
  def change
    add_column :notices, :payment_required, :boolean, default: false
    add_column :notices, :payment_successful, :boolean, default: nil
  end

  def down
    remove_column :notices, :payment_successful
    remove_column :notices, :payment_required
  end

end
