class AddDescriptionTextCacheToLeagues < ActiveRecord::Migration[5.0]
  def change
  	add_column :leagues, :description_text_cache, :text, default: "", null: false
  end
end
