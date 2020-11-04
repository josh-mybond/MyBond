class AddVendorToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :vendor, :integer, default: 0

    add_index :contracts, :vendor
  end
end
