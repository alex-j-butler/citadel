class CreateLeagueMatchBookedTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :league_match_booked_times do |t|
      t.integer :match_id, null: false, index: true
      t.integer :user_id,  null: true

      t.datetime :time
      t.boolean :accepted

      t.timestamps null: false
    end

    add_foreign_key :league_match_booked_times, :league_matches, column: :match_id
    add_foreign_key :league_match_booked_times, :users, column: :user_id
  end
end
