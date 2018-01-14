class League
  class Match
    class BookedTime < ApplicationRecord
      belongs_to :user, class_name: 'User'
      belongs_to :match, class_name: 'Match'

      delegate :home_team, to: :match
      delegate :away_team, to: :match
      delegate :league,    to: :match

      enum status: [:pending, :accepted, :rejected]

    end
  end
end
