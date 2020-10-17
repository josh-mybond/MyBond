class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.integer :contract_type, default: 0
      t.integer :customer_id
      t.integer :value,   default: 0
      t.json    :dates,   default: []
      t.json    :amounts, default: []
      t.json    :data
      t.timestamps
    end
  end
end
