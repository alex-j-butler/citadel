class AddConfirmedTimeToMatch < ActiveRecord::Migration[5.0]
  def change
  	add_column :league_matches, :confirmed_time_id, :integer, null: true, index: true
  end
end
