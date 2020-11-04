class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.integer :status, default: 0
      t.string :email
      t.string :mobile
      t.string :message
      t.json   :history
      t.timestamps
    end
  end
end
