class AddWeekBeginningToMatch < ActiveRecord::Migration[5.0]
  def change
  	add_column :league_matches, :week_beginning, :date
  end
end
