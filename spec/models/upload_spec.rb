require "rails_helper"

RSpec.describe Upload, type: :model do
  subject(:upload) { build(:upload) }

  let(:bigger_file) do
    fixture_file_upload("bigger_than_10_mega.mp4")
  end

  let(:max_file_size) { 10 }

  describe "validations" do
    it { is_expected.to validate_presence_of(:file) }
    it { is_expected.to validate_presence_of(:url_hash) }

    it { is_expected.to validate_uniqueness_of(:url_hash) }
  end

  describe "callbacks" do
    before { upload.save }

    describe "before validation .set_params" do
      let(:endpoint) do
        "#{upload.url_hash}/#{upload.filename}"
      end

      it { expect(upload.filename).to eq(upload.file.filename.to_s) }
      it { expect(upload.endpoint).to eq(endpoint) }
    end
  end

  describe "associations" do
    it { is_expected.to have_one_attached(:file) }
  end

  describe "constants" do
    it { expect(described_class::MAX_FILE_SIZE).to eq(max_file_size) }
  end

  describe "file size" do
    before { upload.save }

    describe "when file size is bigger than defined max_file_size" do
      before { upload.file.attach(bigger_file) }

      it { expect(upload).not_to be_valid }
    end

    describe "when file size is smaller than defined max_file_size" do
      it { expect(upload).to be_valid }
    end
  end
end
