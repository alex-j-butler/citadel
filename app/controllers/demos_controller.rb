class DemosController < ApplicationController
  def show
    @demo = Demo.find(params[:id])
  end
end
