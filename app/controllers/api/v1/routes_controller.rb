class Api::V1::RoutesController < ApplicationController
  before_action :route_action!
  before_action :delay

  def index
    render @route.render_type => @route.response_body,
           status: @route.status_code
  end

  def store
    render @route.render_type => @route.response_body,
           status: @route.status_code
  end

  private

  def route_action!
    @route = route_action_service

    return render json: {}, status: :not_found if @route.blank?
  end

  def delay
    sleep @route.delay
  end

  def route_action_service
    route_service.
      call(params[:client], params[:endpoint], method)
  end

  def route_service
    "RouteManager::#{method.titleize}RouteService".constantize
  end

  def method
    request.request_method
  end
end
