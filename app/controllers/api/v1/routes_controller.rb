class Api::V1::RoutesController < ApplicationController
  def index
    if endpoint.blank?
      return render json: { message: "url not found" },
                    status: :not_found
    end

    sleep(endpoint.delay)

    render render_type => endpoint.response_body,
           status: endpoint.status_code
  end

  private

  def client
    @client ||= Client.find_by(url: params[:client])
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
end
