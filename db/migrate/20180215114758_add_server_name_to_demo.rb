class AddServerNameToDemo < ActiveRecord::Migration[5.1]
  def change
  	add_column :demos, :server_name, :string
  end
end
