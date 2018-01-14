class ChangeBookedTimesAccepted < ActiveRecord::Migration[5.0]
  def change
  	remove_column :league_match_booked_times, :accepted

  	add_column :league_match_booked_times, :status, :integer, default: 0
    add_index :league_match_booked_times, :status
  end
end
