# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file

  before_validation :set_params

  validates :file, :url_hash, :filename, :endpoint, presence: true
  validates :url_hash, uniqueness: true

  private

  def set_params
    self.filename = file.filename.to_s
    self.endpoint = "#{url_hash}/#{filename}"
  end
end
