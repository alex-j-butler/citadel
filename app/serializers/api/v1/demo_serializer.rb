module API
  module V1
    class DemoSerializer < API::V1::BaseSerializer
      type :demo
     	
      attributes :id, :demo, :server_name, :map_name, :duration, :blu_score, :red_score
      attributes :processed, :uploaded_by, :created_at

      attribute(:url) { demo_path(object.id) }

      has_many :players, serializer: API::V1::Demos::PlayerSerializer
    end
  end
end
