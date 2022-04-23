class Api::V1::EndpointsController < ApplicationController

  def create
    endpoint = Endpoint.create(
      endpoint: endpoint_params[:endpoint],
      method: endpoint_params[:method],
      content_type: endpoint_params[:content_type],
      status: endpoint_params[:status],
      delay: endpoint_params[:delay],
      response_body: endpoint_params[:response_body],
      client: client
    )

    return render json: endpoint.errors, status: :bad_request if !endpoint.save
 
    render json: endpoint, status: :created
  end

  def update
  end

  def destroy
  end

  private

  def endpoint_params
    params.permit(:endpoint, :method,
      :content_type, :status, :delay, :response_body, :client)
  end

  def client
    Client.find_by(url: endpoint_params[:client])
  end
end
