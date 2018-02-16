module API
  module V1
    class DemoSerializer < ActiveModel::Serializer
      type :demo

      attributes :id, :demo, :server_name, :map_name, :duration, :blu_score, :red_score
      attributes :created_at

      has_many :players, serializer: API::V1::Demos::PlayerSerializer
    end
  end
end
