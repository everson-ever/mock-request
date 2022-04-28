require "rails_helper"

RSpec.describe "Clients", type: :request do
  let(:client) { build(:client) }
  let(:endpoint) { build(:endpoint, client: client) }

  describe "GET /clients" do
    describe "when client don't exists" do
      before { get "/api/v1/clients/#{client.url}" }

      it "shoul returns empty array" do
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
          expect(json_body.first[:id]).to eq(endpoint.id)
        end
      end

      describe "when dont has endpoints" do
        describe "when has endpoints" do
          before do
            client.save

            get "/api/v1/clients/#{client.url}"
          end

          it "returnses endpoints" do
            expect(json_body).to eq([])
          end
        end
      end
    end
  end

  describe "POST /clients" do
    before { post "/api/v1/clients" }

    it "have key id" do
      expect(json_body).to have_key(:id)
    end

    it "have key url" do
      expect(json_body).to have_key(:url)
    end

    it "have key disabled" do
      expect(json_body).to have_key(:disabled)
    end

    it "have key created_at" do
      expect(json_body).to have_key(:created_at)
    end

    it "have key updated_at" do
      expect(json_body).to have_key(:updated_at)
    end

    it "creates with disabled equal false" do
      expect(json_body[:disabled]).to be_falsy
    end
  end
end
