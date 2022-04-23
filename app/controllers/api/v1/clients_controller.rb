class Api::V1::ClientsController < ApplicationController
  def show
    client = Client.find_by(url: params[:url]).endpoints
    render json: client
  end

  def create
    client = Client.create(url: SecureRandom.hex)
    render json: client
  end
end
