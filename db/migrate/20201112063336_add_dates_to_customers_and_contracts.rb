class AddDatesToCustomersAndContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :date_of_birth, :datetime, default: nil

    add_column :contracts, :start_date, :datetime, default: nil
    add_column :contracts, :end_date,   :datetime, default: nil

    add_index :contracts, :start_date
    add_index :contracts, :end_date
  end
end
