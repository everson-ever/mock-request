require "rails_helper"

RSpec.describe EndpointManager::CreateService do
  subject(:service) { described_class.call(params) }

  let(:client) { create(:client) }
  let(:endpoint) { build(:endpoint, client: client) }
  let(:params) do
    {
      endpoint: endpoint.endpoint,
      request_method: endpoint.request_method,
      content_type: endpoint.content_type,
      status_code: endpoint.status_code,
      delay: endpoint.delay,
      response_body: endpoint.response_body,
      client: client.url
    }
  end

  describe "when endpoint not exists" do
    describe "with valid params" do
      it "persists endpoint" do
        expect(service).to be_persisted
      end
    end

    describe "with invalid content_type" do
      before { endpoint.content_type = :invalid_content_type }

      it "endpoint should not be persisted" do
        expect(service).not_to be_persisted
      end
    end

    describe "with invalid request_method" do
      before { endpoint.request_method = :invalid_request_method }

      it "endpoint should not be persisted" do
        expect(service).not_to be_persisted
      end
    end
  end

  describe "when endpoint exists" do
    before { endpoint.save }

    it "endpoint should not be persisted" do
      expect(service).not_to be_persisted
    end
  end
end
