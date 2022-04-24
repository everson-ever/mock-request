require "rails_helper"

RSpec.describe "Clients", type: :request do
  let(:client) { build(:client) }
  let(:endpoint) { build(:endpoint, client: client) }

  describe "GET /clients" do
    before { get "/api/v1/clients/#{client.url}" }

    describe "when client don't exists" do
      it "shoul returns empty array" do
        json_body = JSON.parse(response.body)
        expect(json_body).to eq([])
      end
    end

    describe "when client exists" do
      before { client.save }

      describe "when has endpoints" do
        before do
          client.save
          endpoint.save

          get "/api/v1/clients/#{client.url}"
        end

        it "returnses endpoints" do
          json_body = JSON.parse(response.body)
          expect(json_body.first["id"]).to eq(endpoint.id)
        end
      end

      describe "when dont has endpoints" do
        describe "when has endpoints" do
          before do
            client.save

            get "/api/v1/clients/#{client.url}"
          end

          it "returnses endpoints" do
            json_body = JSON.parse(response.body)
            expect(json_body).to eq([])
          end
        end
      end
    end
  end
end
