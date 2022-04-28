module EndpointManager
  class CreateService < ApplicationService
    def initialize(endpoint_params)
      @endpoint_params = endpoint_params
    end

    def call
      endpoint.save

      endpoint
    end

    private

    def endpoint
      @endpoint ||= Endpoint.new(
        endpoint: @endpoint_params[:endpoint],
        request_method: @endpoint_params[:request_method],
        content_type: @endpoint_params[:content_type],
        status_code: @endpoint_params[:status_code],
        delay: @endpoint_params[:delay],
        response_body: @endpoint_params[:response_body],
        client: client
      )
    end

    def client
      Client.find_by(url: @endpoint_params[:client])
    end
  end
end
