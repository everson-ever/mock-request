require "rails_helper"

RSpec.describe RouteManager::GetRouteService do
  subject(:service) do
    described_class.call(client.url, endpoint.endpoint, request_method)
  end

  let(:client) { build(:client) }
  let(:endpoint) { create(:endpoint, request_method: "GET", client: client) }

  describe "when request method is GET" do
    let(:request_method) { "GET" }

    describe "when has endpoint with request method GET" do
      it { expect(service).to eq(endpoint) }
    end

    describe "when dont has endpoint with request method GET" do
      before { endpoint.update(request_method: "POST") }

      it { expect(service).to eq(nil) }
    end
  end

  describe ".privates" do
    subject(:service) do
      described_class.new(client.url, endpoint.endpoint, request_method)
    end

    let(:request_method) { "GET" }

    describe ".client" do
      it { expect(service.send(:client)).to eq(client) }
    end

    describe ".endpoint" do
      it { expect(service.send(:endpoint)).to eq(endpoint) }
    end
  end
end
