class AddMobileToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :iso_country_code, :string, default: "AU"
    add_column :customers, :mobile_number,    :string
  end
end
