class CreateDemos < ActiveRecord::Migration[5.1]
  def change
    create_table :demos do |t|
      t.string :demo
      t.string :map_name
      t.integer :blu_score, default: 0
      t.integer :red_score, default: 0

      t.timestamps
    end
  end
end
