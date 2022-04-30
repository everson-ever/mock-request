module RouteManager
  class PostRouteService < ApplicationService
    def initialize(client, endpoint, method)
      @client_param = client
      @endpoint_param = endpoint
      @method = method
    end

    def call
      return if client.blank? || endpoint.blank?

      endpoint
    end

    private

    def client
      @client ||= Client.find_by(url: @client_param)
    end

    def endpoint
      @endpoint ||= client.endpoints.find_by(
        endpoint: @endpoint_param,
        request_method: @method
      )
    end
  end
end
