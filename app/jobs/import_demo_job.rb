class ImportDemoJob < ApplicationJob
  queue_as :default

  def perform(demo)
    demo_import_exec = Rails.root.join('bin', 'demo-import').to_s
    demo_path = demo.demo.file.path

    demo_json = `#{demo_import_exec} #{demo_path} 2> /dev/null`
    imported_demo = JSON.parse(demo_json)

    demo.update_attributes map_name: imported_demo['map_name'],
      blu_score: imported_demo['blu_score'],
      red_score: imported_demo['red_score'],
      duration: imported_demo['duration'].to_i,
      server_name: imported_demo['server_name']

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

    demo.update_attributes processed: true
  end
end
