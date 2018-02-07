require 'admin_bar/controller_helpers'

module AdminBar
  class Railtie < ::Rails::Engine
    isolate_namespace AdminBar
    engine_name :admin_bar

    config.after_initialize do
      ActiveSupport.on_load(:action_controller) do
        include AdminBar::ControllerHelpers
      end

      ActiveSupport::Notifications.subscribe('process_action.action_controller') do
        AdminBar.save
        AdminBar.clear
      end
    end 
  end
end
