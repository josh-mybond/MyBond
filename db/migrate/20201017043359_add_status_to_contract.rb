class AddStatusToContract < ActiveRecord::Migration[6.0]

  def change
    add_column :contracts, :status, :integer, default: 0

    add_index :contracts, :status
  end

end
