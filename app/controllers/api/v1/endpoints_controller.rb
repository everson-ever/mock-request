class Api::V1::EndpointsController < ApplicationController
  def create
    unless endpoint.save
      return render json: endpoint.errors, status: :bad_request
    end

    render json: endpoint, status: :created
  end

  def update; end

  def destroy; end

  private

  def endpoint
    Endpoint.new(
      endpoint: endpoint_params[:endpoint],
      request_method: endpoint_params[:request_method],
      content_type: endpoint_params[:content_type],
      status_code: endpoint_params[:status_code],
      delay: endpoint_params[:delay],
      response_body: endpoint_params[:response_body],
      client: client
    )
  end

  def endpoint_params
    params.permit(:endpoint, :request_method,
      :content_type, :status_code, :delay, :response_body, :client)
  end

  def client
    Client.find_by(url: endpoint_params[:client])
  end
end
