module AdminBar
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_adminbar_request_id, if: :adminbar_enabled?
      helper_method :adminbar_enabled? if respond_to? :helper_method
    end

    protected

    def set_adminbar_request_id
      AdminBar.request_id = request.env['action_dispatch.request_id']
    end

    def adminbar_enabled?
      ['development', 'staging'].include? AdminBar.env
    end
  end
end
