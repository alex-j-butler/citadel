class DemosController < ApplicationController
  def index
    @demos = Demo.paginate(page: params[:page])
                 .order('created_at DESC')
                 .load
  end

  def show
    @demo = Demo.find(params[:id])
  end
end
