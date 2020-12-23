class AddStatusToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :status, :integer, default: 0

    add_index :customers, :status
  end
end
