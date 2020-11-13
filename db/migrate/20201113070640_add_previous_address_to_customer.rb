class AddPreviousAddressToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :previous_address, :string
    add_column :customers, :previous_agent,   :string
  end
end
