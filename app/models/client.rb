# frozen_string_literal: true

class Client < ApplicationRecord
  has_many :endpoints, dependent: :destroy

  validates :url, presence: true
end
