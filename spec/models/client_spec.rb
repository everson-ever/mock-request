require "rails_helper"

RSpec.describe Client, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe "associations" do
    it { is_expected.to have_many(:endpoints) }
  end
end
