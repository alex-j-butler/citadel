require 'json'
require 'net/http'

STEAM_KEY = Rails.application.secrets.steam_api_key

def steam_bans(ids)
  ids_str = ids.join(',')

  url = "http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=#{STEAM_KEY}&steamids=#{ids_str}"

  response = Net::HTTP.get(URI(url))

  json = JSON.parse(response)
  players = json['players']
  players.select { |player| player['VACBanned'] }
         .map { |player| player['SteamId'] }
end

all_users = User.all
users_grouped = all_users.each_slice(100).to_a

users_grouped.each do |users|
  steam_ids = users.map(&:steam_id)

  user_bans = steam_bans(steam_ids)
  user_bans.each do |id|
    user = User.find_by(steam_id: id)

    if user.vac_clean?
      user.vac_status = :vac_banned
      user.save

      puts "#{user.name} newly vac banned"
    end
  end
end
