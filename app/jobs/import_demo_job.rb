class ImportDemoJob < ApplicationJob
  queue_as :default

  def perform(*args)
    demo_json = `#{Rails.root}/demo-import ~/Documents/demo-parser/20180211-2154-pl_badwater_pro_v12.dem 2> /dev/null`
    imported_demo = JSON.parse(demo_json)

    demo = Demo.create map_name: imported_demo['map_name'],
      blu_score: imported_demo['blu_score'],
      red_score: imported_demo['red_score']

    imported_demo['users'].each do |user|
      team = 'red' if user['team'] == 'red'
      team = 'blu' if user['team'] == 'blue'

      if team
        user['classes'].each do |user_class|
          Demo::Player.create steam_name: user['steam_name'],
            steam_id: SteamId::to_64(user['steam_id'][1..-2]),
            team: team,
            player_class: user_class,
            player_class_active: true,
            demo: demo if SteamId::valid_id3?(user['steam_id'][1..-2])
        end
      end
    end
  end
end
