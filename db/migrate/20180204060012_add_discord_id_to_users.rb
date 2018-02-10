class AddDiscordIdToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :discord_id, :bigint
  end
end
