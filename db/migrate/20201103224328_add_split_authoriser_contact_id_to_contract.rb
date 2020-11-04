class AddSplitAuthoriserContactIdToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :split_authoriser_contact_id, :string

    add_index :contracts, :split_authoriser_contact_id
  end
end
