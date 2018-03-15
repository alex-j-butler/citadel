class AddVacStatusToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :vac_status, :integer, default: 0
  end
end
