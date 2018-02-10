require 'net/http'
require 'json'

DISCORD_HOST = 'https://discordapp.com/api'
DISCORD_API_KEY = ENV['DISCORD_API_KEY']
DISCORD_GUILD_ID = '210591935352537088'

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

User.find_in_batches(batch_size: 10) do |users|
  users.each do |user|
    if user.discord_id
      roles = get_roles_for_user(user.discord_id)

      roles.each do |role| 
        role_sym = role.to_sym
        if ROLES[role_sym]
          role_def = ROLES[role_sym]

          perms = role_def[:roles]
          badge_name = role_def[:name]
          badge_colour = role_def[:colour]

          perms.each do |permission|
            user.grant(*permission) unless user.can?(*permission)
          end
          user.badge_name = badge_name
          user.badge_color = badge_colour
          user.save
        end
      end
    end
  end
end
