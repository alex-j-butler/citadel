class DemoPresenter < BasePresenter
  presents :demo

  def id
    demo.id
  end

  def other_players
    players = demo.players.count - 1
    pluralize(players, 'other player')
  end

  def map_name
    if demo.map_name
      demo.map_name
    else
      'Unknown'
    end
  end

  def summary
    "#{map_name} played with #{other_players}"
  end

  def download_link
    link_to 'Download', demo.demo.url
  end

  def time_ago
    "Played #{time_ago_in_words(demo.created_at)} ago"
  end

  def token
    "demo-#{demo.id}"
  end

  def blu_score
    demo.blu_score
  end

  def red_score
    demo.red_score
  end

  def red_players
    demo.players.select { |player| player.team == 'red' }
  end

  def blu_players
    demo.players.select { |player| player.team == 'blu' }
  end
end
