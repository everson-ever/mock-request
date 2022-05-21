# frozen_string_literal: true

class Upload < ApplicationRecord
  MAX_FILE_SIZE = 10

  has_one_attached :file

  before_validation :set_params

  validates :file, :url_hash, presence: true
  validates :url_hash, uniqueness: true

  validates :file, size: { 
    less_than: MAX_FILE_SIZE.megabytes,
    message: "must be less than #{MAX_FILE_SIZE}MB in size"
  }

  private

  def set_params
    self.filename = file.filename.to_s
    self.endpoint = "#{url_hash}/#{filename}"
  end
end
