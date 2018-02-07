class AdminBarController < ApplicationController
  def results
    render json: AdminBar.get(params[:request_id])
  end
end
