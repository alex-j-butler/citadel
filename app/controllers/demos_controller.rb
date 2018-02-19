class DemosController < ApplicationController
  def index
    @demos = Demo.where(processed: true)
    			 .order('created_at DESC')
                 .search(params[:q])
                 .paginate(page: params[:page])
                 .load
  end

  def show
    @demo = Demo.find(params[:id])
  end
end
