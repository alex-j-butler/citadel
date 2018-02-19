module API
  module V1
    class BaseSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers
    end
  end
end