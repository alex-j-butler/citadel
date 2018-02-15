class AddDurationToDemo < ActiveRecord::Migration[5.1]
  def change
  	add_column :demos, :duration, :integer
  end
end
