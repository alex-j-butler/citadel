class ApplicationController < ActionController::Base
  include ApplicationPermissions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  impersonates :user

  before_action do
    @notifications = current_user.notifications.order(created_at: :desc).load if user_signed_in?

    @recent_threads = Rails.cache.fetch('recent_threads', expires_in: 10.minutes) do
      Forums::Thread.new_ordered.take(5)
    end
  end

  def adminbar_enabled?
    user_signed_in? && true_user.admin?
  end

  after_action :track_action

  protected

  def require_login
    redirect_back(fallback_location: root_path) unless user_signed_in?
  end

  def track_action
    ahoy.track "#{request.method} #{request.fullpath}", request.filtered_parameters.to_s
  end
end
