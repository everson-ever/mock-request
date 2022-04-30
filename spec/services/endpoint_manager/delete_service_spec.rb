require "rails_helper"

RSpec.describe EndpointManager::DeleteService do
  subject(:service) { described_class.call(params) }

  let(:client) { build(:client) }
  let(:endpoint) { create(:endpoint, client: client) }
  let(:params) do
    {
      client: client.url,
      endpoint: endpoint.endpoint,
      request_method: endpoint.request_method
    }
  end

  describe "when try delete a existing endpoint" do
    describe "when the method is equal the existing endpoint in client" do
      before { service }

      it "deletes endpoint" do
        expect(Endpoint.find_by(id: endpoint.id)).not_to be_present
      end
    end

    describe "when the method is not equal the existing endpoint in client" do
      before do
        params[:request_method] = "POST"

        service
      end

      it "does not delete endpoint" do
        expect(Endpoint.find_by(id: endpoint.id)).to be_present
      end
    end
  end

  describe "when endpoint not exist" do
    before do
      endpoint.save
      endpoint.destroy
    end

    it { expect(service).to eq(nil) }
  end
end
