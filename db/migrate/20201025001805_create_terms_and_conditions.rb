class CreateTermsAndConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :terms_and_conditions do |t|
      t.integer :status, default: 0
      t.string  :summary
      t.string  :full
      t.string  :version
      t.timestamps
    end
  end
end
