class MarkdownController < ApplicationController
  
  def handle_error(error)
    if error.is_a? ActiveRecord::RecordNotFound
      render_not_found
    elsif error.is_a? ActionController::RoutingError
      render_not_found message: 'Unknown route'
    else
      throw error if Rails.env.test?

      json = { message: 'Internal error' }
      json[:traceback] = error.backtrace if Rails.env.development?

      render_error :internal_server_error, json
    end
  end

  def render_error(status_code, json)
    json[:status] ||= Rack::Utils.status_code(status_code)

    render status: status_code, json: json
  end
  
  def preview
    mkdown_html = { html: MarkdownRenderer.render(preview_params[:markdown], true) }
    render json: mkdown_html
  end

  def preview_params
    params.permit(:markdown)
  end

end
