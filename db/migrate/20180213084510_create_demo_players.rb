class CreateDemoPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_players do |t|
      t.string :steam_name, null: false
      t.bigint :steam_id, null: false
      t.integer :team, default: 0
      t.integer :player_class, default: 0
      t.boolean :player_class_active, default: true
      t.belongs_to :demo

      t.timestamps
    end
  end
end
