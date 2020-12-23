class AddNewStatusToContract < ActiveRecord::Migration[6.0]
  def change
    Contract.all.each do |c|
      c.status += 1
      c.save
    end
  end
end
