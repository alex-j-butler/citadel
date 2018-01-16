FactoryGirl.define do
  factory :booked_time, class: League::Match::BookedTime do
    association :match, factory: :league_match
    time Time.now
  end

  factory :booked_time_home_team, class: League::Match::BookedTime do
  	association :match, factory: :league_match

  	after(:build) do |booked_time, evaluator|
      booked_time.user = booked_time.match.home_team.players.first.user
    end
  end

  factory :booked_time_away_team, class: League::Match::BookedTime do
  	association :match, factory: :league_match

  	after(:build) do |booked_time, evaluator|
      booked_time.user = booked_time.match.away_team.players.first.user
    end
  end
end
