require "rails_helper"

RSpec.describe RouteManager::PostRouteService do
  subject(:service) do
    described_class.call(client.url, endpoint.endpoint, request_method)
  end

  let(:client) { build(:client) }
  let(:endpoint) { create(:endpoint, request_method: "POST", client: client) }

  describe "when request method is POST" do
    let(:request_method) { "POST" }

    describe "when has endpoint with request method POST" do
      it { expect(service).to eq(endpoint) }
    end

    describe "when dont has endpoint with request method POST" do
      before { endpoint.update(request_method: "GET") }

      it { expect(service).to eq(nil) }
    end
  end

  describe ".privates" do
    subject(:service) do
      described_class.new(client.url, endpoint.endpoint, request_method)
    end

    let(:request_method) { "POST" }

    describe ".client" do
      it { expect(service.send(:client)).to eq(client) }
    end

    describe ".endpoint" do
      it { expect(service.send(:endpoint)).to eq(endpoint) }
    end
  end
end
