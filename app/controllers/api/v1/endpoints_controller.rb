class Api::V1::EndpointsController < ApplicationController
  def create
    endpoint = EndpointManager::CreateService.call(endpoint_params)

    unless endpoint.persisted?
      return render json: endpoint.errors, status: :bad_request
    end

    render json: endpoint, status: :created
  end

  def update; end

  def destroy
    render json: EndpointManager::DeleteService.call(params), status: 204
  end

  private

  def endpoint_params
    params.permit(:endpoint, :request_method,
      :content_type, :status_code, :delay, :response_body, :client)
  end
end
