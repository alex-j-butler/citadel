class AddConfirmedMatchToTime < ActiveRecord::Migration[5.0]
  def change
  	remove_column :league_matches, :confirmed_time_id
  	add_column :league_match_booked_times, :confirmed_match_id, :integer, null: true, index: true
  end
end
