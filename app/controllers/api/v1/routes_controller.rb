class Api::V1::RoutesController < ApplicationController
  def index
    return render json: { message: "url not found" },
      status: :not_found if endpoint.blank?

    sleep(endpoint.delay)

    return render render_type => endpoint.response_body,
      status: endpoint.status
  end

  private

  def client
    @client ||= Client.find_by(url: params[:client])
  end

  def endpoint
    client.endpoints.where(
      endpoint: "/#{params[:endpoint]}",
      method: request.method
    ).first
  end

  def render_type
    endpoint.render_type.to_sym
  end
end