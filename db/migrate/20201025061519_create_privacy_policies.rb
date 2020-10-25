class CreatePrivacyPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_policies do |t|
      t.integer :status, default: 0
      t.string  :summary
      t.string  :full
      t.string  :version
      t.timestamps
    end
  end
end
