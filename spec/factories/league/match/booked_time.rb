FactoryGirl.define do
  factory :booked_time, class: League::Match::BookedTime do
    association :match, factory: :league_match
    time Time.now
  end
end
