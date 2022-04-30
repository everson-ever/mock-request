module EndpointManager
  class DeleteService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      return if client.blank? || endpoint.blank?

      endpoint.destroy
    end

    private

    def client
      @client ||= Client.find_by(url: @params[:client])
    end

    def endpoint
      @endpoint ||= client.endpoints.find_by(
        endpoint: "#{slash}#{@params[:endpoint]}",
        request_method: @params[:request_method]
      )
    end

    def slash
      "/" unless @params[:endpoint].first == "/"  
    end
  end
end
