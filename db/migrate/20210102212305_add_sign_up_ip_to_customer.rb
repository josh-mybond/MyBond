class AddSignUpIpToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :signup_ip, :string
  end
end
