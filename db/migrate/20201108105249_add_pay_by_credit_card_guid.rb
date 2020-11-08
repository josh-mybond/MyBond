class AddPayByCreditCardGuid < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :pay_by_credit_card_guid, :string

    add_index :contracts, :pay_by_credit_card_guid
  end
end
