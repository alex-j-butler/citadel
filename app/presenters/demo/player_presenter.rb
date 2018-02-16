class Demo
  class PlayerPresenter < BasePresenter
    presents :player

    def steam_url
      "http://steamcommunity.com/profiles/#{player.steam_id}"
    end

    def link
      if user
        link_to player.steam_name, user_path(user)
      else
        link_to player.steam_name, steam_url, class: 'unregistered'
      end
    end

    def user
      User.where(steam_id: player.steam_id).first
    end

    def steam_id
      player.steam_id
    end

    def classes
      classes = ''

      player_classes = Demo::Player.where(demo_id: player.demo.id, team: player.team, steam_id: player.steam_id)
        .map do |player|
          { player_class: player.player_class,
            active: player.player_class_active }
        end
      
      player_classes.each do |clazz|
        classes += class_img(clazz)
      end
      classes
    end

    private

    def class_img(clazz)
      options ||= {class: 'class-icon'}
      options[:class] += ' inactive' unless clazz[:active]

      # image_tag "class_icons/#{clazz[:player_class]}", options
      image_tag 'class_icons/spy', options
    end
  end
end