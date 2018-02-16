module API
  module V1
    module Demos
      class PlayerSerializer < ActiveModel::Serializer
        type :player

        attributes :id, :steam_name, :steam_id, :team, :player_class, :player_class_active
      end
    end
  end
end
