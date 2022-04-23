class Client < ApplicationRecord
  has_many :endpoints, dependent: :destroy

  validates :url, presence: true
end
