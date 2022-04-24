class Api::V1::ClientsController < ApplicationController
  before_action :set_client, only: [:show]

  def show
    return render json: [] if @client.blank?

    endpoints = @client.endpoints
    render json: endpoints
  end

  def create
    client = Client.create(url: SecureRandom.hex)
    render json: client
  end

  private

  def set_client
    @client = Client.find_by(url: params[:url])
  end
end
