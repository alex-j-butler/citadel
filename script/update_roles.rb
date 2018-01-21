require 'net/http'
require 'json'

DISCORD_HOST = 'https://discordapp.com/api'
DISCORD_API_KEY = ARGV[1]
DISCORD_GUILD_ID = '210591935352537088'

USERS = [
  { id: 1, discord: '97305840196808704' }, # Alex
  { id: 2, discord: '112506587825876992' }, # Brion
  { id: 3, discord: '97272043866689536' }, # Kodyn
  { id: 4, discord: '131609154333704192' }, # Fargoth
  { id: 6, discord: '140763409519083520' }, # Hyper
  { id: 19, discord: '226205616773922816' }, # Core
  { id: 23, discord: '174861732542414848' }, # KeaneCat
]

ROLES = {
  '299796241506631683': { name: 'Admin', colour: 0, roles: [[:edit, :users], [:edit, :teams], [:edit, :games], [:edit, :leagues], [:manage_rosters, :leagues], [:impersonate, :users], [:manage, :forums]] }, # Admin
  '364027979736547328': { name: 'Moderator', colour: 1, roles: [[:edit, :users], [:edit, :teams], [:edit, :leagues], [:manage_rosters, :leagues], [:manage, :forums]] } # Moderator
}

def get_roles_for_user(discord_id)
  url = "#{DISCORD_HOST}/guilds/#{DISCORD_GUILD_ID}"
  uri = URI(url)
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = DISCORD_API_KEY
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
    http.request(req)
  }

  json = JSON.parse(response.body)

  url = "#{DISCORD_HOST}/guilds/#{DISCORD_GUILD_ID}/members/#{discord_id}"
  uri = URI(url)
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = DISCORD_API_KEY
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
    http.request(req)
  }

  json = JSON.parse(response.body)

  return json['roles']
end

USERS.each do |user|
  roles = get_roles_for_user(user[:discord])
  user_id = user[:id]

  roles.each do |role|
    role_sym = role.to_sym
    if ROLES[role_sym]
      role_def = ROLES[role_sym]

      perms = role_def[:roles]
      badge_name = role_def[:name]
      badge_colour = role_def[:colour]

      citadel_user = User.find(user_id)
      if citadel_user
        perms.each do |permission|
          citadel_user.grant(*permission) unless citadel_user.can?(*permission)
        end
        citadel_user.badge_name = badge_name
        citadel_user.badge_color = badge_colour
        citadel_user.save
      end
    end
  end
end
