class AddResidentialStatusToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :residential_status, :integer, default: 0
  end
end
