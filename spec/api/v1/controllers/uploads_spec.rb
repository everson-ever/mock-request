require "rails_helper"

RSpec.describe "Uploads", type: :request do
  let(:small_file) do
    fixture_file_upload("less_than_10_mega.mp3")
  end

  let(:big_file) do
    fixture_file_upload("bigger_than_10_mega.mp4")
  end

  describe "POST /uploads" do
    describe "when file is less than max_file_size" do
      before { post "/api/v1/uploads", params: params }

      let(:params) { { "file" => small_file } }

      it { expect(response.body).to match(small_file.original_filename) }
    end

    describe "when file is bigger than max_file_size" do
      before { post "/api/v1/uploads", params: params }

      let(:params) { { "file" => big_file } }

      let(:error_message) do
        {
          file: ["must be less than 10MB in size"]
        }
      end

      it { expect(json_body).to match(error_message) }
    end
  end
end
