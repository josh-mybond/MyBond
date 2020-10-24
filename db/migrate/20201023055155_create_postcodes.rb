class CreatePostcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :postcodes do |t|
      t.string :postcode, null: false, default: ""
      t.float  :risk,       default: 0
      t.float  :risk_limit, default: 0.8
      t.timestamps
    end

    add_index :postcodes, :postcode
  end
end
