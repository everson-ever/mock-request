require "rails_helper"

RSpec.describe "Endpoints", type: :request do
  let(:endpoint) { build(:endpoint, client: client) }
  let(:params) do
    {
      endpoint: endpoint.endpoint,
      request_method: endpoint.request_method,
      content_type: endpoint.content_type,
      status_code: endpoint.status_code,
      delay: endpoint.delay,
      response_body: endpoint.response_body,
      client: endpoint.client.url
    }
  end

  describe "POST /endpoints" do
    let(:client) { create(:client) }

    describe "when have all required attributes" do
      describe "with valid values" do
        before do
          client.save

          post "/api/v1/endpoints", params: params.as_json
        end

        it { expect(response.status).to eq(201) }
        it { expect(json_body[:endpoint]).to eq(endpoint.endpoint) }
        it { expect(json_body[:delay]).to eq(endpoint.delay) }
        it { expect(json_body[:response_body]).to eq(endpoint.response_body) }
        it { expect(json_body[:request_method]).to eq(endpoint.request_method) }
        it { expect(json_body[:content_type]).to eq(endpoint.content_type) }
        it { expect(json_body[:client_id]).to eq(endpoint.client_id) }
        it { expect(json_body).to have_key(:created_at) }
        it { expect(json_body).to have_key(:updated_at) }
      end

      describe "when endpoint already existsin client" do
        before do
          client.save
          endpoint.save

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { endpoint: ["has already been taken"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with client nonexistent" do
        before do
          client.save
          params[:client] = "invalid client"

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { client: ["must exist", "can't be blank"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with missing endpoint value" do
        before do
          client.save
          params[:endpoint] = nil

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { endpoint: ["can't be blank"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with missing request_method value" do
        before do
          client.save
          params[:request_method] = nil

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { request_method: ["can't be blank", "is not included in the list"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with missing content_type value" do
        before do
          client.save
          params[:content_type] = nil

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { content_type: ["can't be blank", "is not included in the list"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with unallowed value to content_type" do
        before do
          client.save
          params[:content_type] = "application/bad_value"

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { content_type: ["is not included in the list"] }
        end

        it { expect(json_body).to eq(error_message) }
      end

      describe "with unallowed value to request_method" do
        before do
          client.save
          params[:request_method] = "FOO"

          post "/api/v1/endpoints", params: params.as_json
        end

        let(:error_message) do
          { request_method: ["is not included in the list"] }
        end

        it { expect(json_body).to eq(error_message) }
      end
    end
  end
end
