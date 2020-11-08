class RemoveConfusingField < ActiveRecord::Migration[6.0]
  def change
    remove_column :contracts, :weekly_rent
  end
end
