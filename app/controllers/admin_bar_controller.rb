class AdminBarController < ApplicationController
  before_action :require_admin_bar

  def results
    render json: AdminBar.get(params[:request_id])
  end

  private

  def require_admin_bar
    raise ActionController::RoutingError.new('Not Found') unless adminbar_enabled?
  end

end
