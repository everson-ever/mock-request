FactoryBot.define do
  factory :upload do
    url_hash { SecureRandom.hex }
    filename { :filename }
    endpoint { "aaa/filename.png" }
    file do
      Rack::Test::UploadedFile.new("spec/fixtures/files/less_than_10_mega.mp3")
    end
  end
end
