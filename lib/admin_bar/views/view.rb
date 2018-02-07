module AdminBar
  module Views
    class View
      def initialize(options = {})
        @options = options

        parse_options
        setup_subscribers
      end

      def parse_options
      end

      def setup_subscribers
      end

      def enabled?
        true
      end

      def partial
        self.class.to_s.underscore
      end

      def title
        self.class.to_s.split('::').last.downcase
      end

      def key
        self.class.to_s.split('::').last.underscore.gsub(/\_/, '-')
      end
      alias defer_key key

      def context_id
        "adminbar-context-#{key}"
      end

      def dom_id
        "adminbar-view-#{key}"
      end

      def results
        {}
      end

      def results?
        results.any?
      end

      def subscribe(*args)
        ActiveSupport::Notifications.subscribe(*args) do |name, start, finish, id, payload|
          yield name, start, finish, id, payload
        end
      end

      def before_request
        subscribe 'start_processing.action_controller' do |name, start, finish, id, payload|
          yield name, start, finish, id, payload
        end
      end

      def after_request
        subscribe 'process_action.action_controller' do |name, start, finish, id, payload|
          yield name, start, finish, id, payload
        end
      end
    end
  end
end
