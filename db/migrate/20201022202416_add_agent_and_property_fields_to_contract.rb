class AddAgentAndPropertyFieldsToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :agent_name,         :string
    add_column :contracts, :agent_telephone,    :string
    add_column :contracts, :agent_email,        :string
    add_column :contracts, :property_weekly_rent, :integer
    add_column :contracts, :property_address,   :string
    add_column :contracts, :property_postcode,  :string
    add_column :contracts, :property_iso_country_code, :string, default: "AU"
    add_column :contracts, :rental_bond_board_id, :string

    add_index :contracts, :property_postcode
  end
end
