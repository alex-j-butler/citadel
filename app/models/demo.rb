class Demo < ApplicationRecord
  has_many :players, class_name: 'Demo::Player'

  mount_uploader :demo, DemoUploader

  scope :search, (lambda do |query|
    return order(:id) if query.blank?

    steam_id = SteamId.to_64(query)
    query = Search.transform_query(query)

    joins(:players).where('(demo_players.steam_id = ?) OR (demo_players.steam_name <-> ?) < 0.9', steam_id, query)
  end)
end
