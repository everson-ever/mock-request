class Api::V1::HomeController < ApplicationController
  def index
    render json: {
      status: :ok,
      message: "application is online in #{Time.zone.now}"
    }
  end
end
