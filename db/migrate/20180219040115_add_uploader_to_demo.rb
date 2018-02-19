class AddUploaderToDemo < ActiveRecord::Migration[5.1]
  def change
  	add_column :demos, :uploaded_by, :string
  end
end
