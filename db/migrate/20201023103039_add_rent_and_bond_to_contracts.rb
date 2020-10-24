class AddRentAndBondToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :rental_bond, :integer, default: 0
  end
end
