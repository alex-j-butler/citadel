class AddDescriptionTextCacheToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :description_text_cache, :text, default: "", null: false
  end
end
