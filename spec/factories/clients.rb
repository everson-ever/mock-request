FactoryBot.define do
  factory :client do
    url { SecureRandom.hex }
    disabled { false }
  end
end
