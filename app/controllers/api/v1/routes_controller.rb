class Api::V1::RoutesController < ApplicationController
  def index
    if client.blank? || endpoint.blank?
      return render json: url_not_found, status: :not_found
    end

    sleep endpoint.delay

    render render_type => endpoint.response_body,
           status: endpoint.status_code
  end

  private

  def client
    @client = Client.find_by(url: params[:client])
  end

  def endpoint
    client.endpoints.where(
      endpoint: "/#{params[:endpoint]}",
      request_method: request.request_method
    ).first
  end

  def render_type
    endpoint.render_type
  end

  def url_not_found
    { message: "url not found" }
  end
end
