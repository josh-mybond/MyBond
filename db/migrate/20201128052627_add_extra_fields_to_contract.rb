class AddExtraFieldsToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :start_of_lease, :datetime
    add_column :contracts, :end_of_lease,   :datetime
    add_column :contracts, :rolling_lease,  :boolean, default: false
  end
end
