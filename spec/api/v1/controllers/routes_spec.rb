require "rails_helper"

RSpec.describe "Routes", type: :request do
  let(:client) { build(:client) }
  let(:endpoint) { build(:endpoint, client: client) }

  describe "GET /routes" do
    describe "when full url exists (client and endpoint)" do
      describe "endpoint content_type" do
        describe "when content_type is application/json" do
          before do
            endpoint.content_type = "application/json"
            endpoint.response_body = "{'name': 'mock'}"
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.body).to eq(endpoint.response_body) }
          it { expect(response.content_type).to match(endpoint.content_type) }
        end

        describe "when content_type is application/xml" do
          before do
            endpoint.content_type = "application/xml"
            endpoint.response_body = "<name>Mock</name>"
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.body).to eq(endpoint.response_body) }
          it { expect(response.content_type).to match(endpoint.content_type) }
        end

        describe "when content_type is text/plain" do
          before do
            endpoint.content_type = "text/plain"
            endpoint.response_body = "text"
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.body).to eq(endpoint.response_body) }
          it { expect(response.content_type).to match(endpoint.content_type) }
        end
      end

      describe "endpoint status_code" do
        describe "when endpoint status_code is 200" do
          before do
            endpoint.status_code = 200
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.status).to match(endpoint.status_code) }
        end

        describe "when endpoint status_code is 400" do
          before do
            endpoint.status_code = 400
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.status).to match(endpoint.status_code) }
        end

        describe "when endpoint status_code is 500" do
          before do
            endpoint.status_code = 500
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it { expect(response.status).to match(endpoint.status_code) }
        end
      end

      describe "endpoint delay" do
        describe "when delay is 1 sec" do
          before do
            endpoint.delay = 1
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it {
            expect(response.header["X-Runtime"].to_f).
            to be >= endpoint.delay
          }
        end

        describe "when delay is 3 sec" do
          before do
            endpoint.delay = 3
            endpoint.save

            get "/api/v1/routes/#{client.url}#{endpoint.endpoint}"
          end

          it {
            expect(response.header["X-Runtime"].to_f).
            to be >= endpoint.delay
          }
        end
      end
    end

    describe "when client dont exists" do
      before do
        get "/api/v1/routes/#{invalid_client_url}#{invalid_endpoint}"
      end

      let(:invalid_client_url) { "invalid-client-url" }
      let(:invalid_endpoint) { "/invalid-endpoint" }
      let(:error_message) { { message: "url not found" } }

      it "shoud return error message" do
        expect(json_body).to eq(error_message)
      end

      it { expect(response.status).to be(404) }
    end

    describe "when client exists and endpoint dont exists" do
      before do
        client.save
        get "/api/v1/routes/#{client.url}#{invalid_endpoint}"
      end

      let(:invalid_endpoint) { "/invalid-endpoint" }
      let(:error_message) { { message: "url not found" } }

      it "shoud return error message" do
        expect(json_body).to eq(error_message)
      end

      it { expect(response.status).to be(404) }
    end
  end
end
