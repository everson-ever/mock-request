require "rails_helper"

RSpec.describe Endpoint, type: :model do
  let(:client) { build(:client) }
  let(:endpoint) { build(:endpoint, client: client) }
  let(:allowed_methods) { %w[GET POST PUT DELETE].freeze }
  let(:allowed_content_types) do
    %w[application/json application/xml text/plain].freeze
  end
  let(:valid_xml) { "<servers></servers>" }
  let(:invalid_xml) { "invalid xml" }
  let(:valid_json) { { name: "mock request" } }
  let(:any_json) { "Any string" }
  let(:valid_text) { { name: "valid text" } }

  describe "constants" do
    it { expect(described_class::METHODS).to eq(allowed_methods) }
    it { expect(described_class::CONTENT_TYPES).to eq(allowed_content_types) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:endpoint) }
    it { is_expected.to validate_presence_of(:request_method) }
    it { is_expected.to validate_presence_of(:content_type) }
    it { is_expected.to validate_presence_of(:client) }

    it {
      expect(endpoint).to validate_inclusion_of(:request_method).
        in_array(described_class::METHODS)
    }

    it {
      expect(endpoint).to validate_inclusion_of(:content_type).
        in_array(described_class::CONTENT_TYPES)
    }

    it {
      expect(endpoint).to validate_uniqueness_of(:endpoint).
        scoped_to(:client_id, :request_method)
    }

    it {
      expect(endpoint).to validate_numericality_of(:delay).
        is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5)
    }

    describe "when missing attributes" do
      describe "when missing endpoint" do
        before do
          endpoint.endpoint = nil

          endpoint.valid?
        end

        let(:error_message) { {:endpoint=>["can't be blank"]} }

        it { expect(endpoint).not_to be_valid }
        it { expect(endpoint.errors.messages).to eq(error_message) }
      end

      describe "when missing request_method" do
        before do
          endpoint.request_method = nil

          endpoint.valid?
        end

        let(:error_message) { {:request_method=>["can't be blank", "is not included in the list"]} }

        it { expect(endpoint).not_to be_valid }
        it { expect(endpoint.errors.messages).to eq(error_message) }
      end

      describe "when missing content_type" do
        before do
          endpoint.content_type = nil

          endpoint.valid?
        end

        let(:error_message) do
          {:content_type=>["can't be blank", "is not included in the list"]}
        end

        it { expect(endpoint).not_to be_valid }
        it { expect(endpoint.errors.messages).to eq(error_message) }
      end
      
      describe "when missing client" do
        before do
          endpoint.client = nil

          endpoint.valid?
        end

        let(:error_message) { {:client=>["must exist", "can't be blank"]} }

        it { expect(endpoint).not_to be_valid }
        it { expect(endpoint.errors.messages).to eq(error_message) }
      end
    end

    describe "when content_type is application/xml" do
      describe "when response_body is a valid xml" do
        before do
          endpoint.content_type = "application/xml"
          endpoint.response_body = valid_xml
        end

        it { expect(endpoint).to be_valid }
      end

      describe "when response_body is a invalid xml" do
        before do
          endpoint.content_type = "application/xml"
          endpoint.response_body = invalid_xml
        end

        it { expect(endpoint).not_to be_valid }
      end

      describe "when response_body is empty" do
        before do
          endpoint.content_type = "application/xml"
          endpoint.response_body = ""
        end

        it { expect(endpoint).to be_valid }
      end
    end

    describe "when content_type is application/json" do
      describe "when response_body is a valid json" do
        before do
          endpoint.content_type = "application/json"
          endpoint.response_body = valid_json.to_json
        end

        it { expect(endpoint).to be_valid }
      end

      describe "when response_body is any string" do
        before do
          endpoint.content_type = "application/json"
          endpoint.response_body = any_json
        end

        it { expect(endpoint).to be_valid }
      end

      describe "when response_body is empty" do
        before do
          endpoint.content_type = "application/json"
          endpoint.response_body = ""
        end

        it { expect(endpoint).to be_valid }
      end
    end

    describe "when content_type is text/plain" do
      describe "when response_body is a valid text" do
        before do
          endpoint.content_type = "text/plain"
          endpoint.response_body = valid_text
        end

        it { expect(endpoint).to be_valid }
      end

      describe "when response_body is empty" do
        before do
          endpoint.content_type = "text/plain"
          endpoint.response_body = ""
        end

        it { expect(endpoint).to be_valid }
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:client) }
  end

  describe "methods" do
    describe "render_type" do
      describe "when content type is application/json" do
        before { endpoint.content_type = "application/json" }

        it { expect(endpoint.render_type).to eq(:json) }
      end

      describe "when content type is application/xml" do
        before { endpoint.content_type = "application/xml" }

        it { expect(endpoint.render_type).to eq(:xml) }
      end

      describe "when content type is plain/text" do
        before { endpoint.content_type = "plain/text" }

        it { expect(endpoint.render_type).to eq(:text) }
      end
    end
  end
end
