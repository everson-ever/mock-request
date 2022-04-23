class Endpoint < ApplicationRecord
  include ContentTypeable

  METHODS = %w[GET POST PUT DELETE]
  CONTENT_TYPES = %w[application/json application/xml text/plain]

  attr_accessor :full_path

  belongs_to :client

  before_validation :response_to_json, if: :content_type_json?
  before_validation :response_to_xml,  if: :content_type_xml?
  before_validation :response_to_text, if: :text_plain?

  validates :endpoint, :method, :content_type,
    :response_body, :client, presence: true

  validates :method, inclusion: { in: METHODS }
  validates :content_type, inclusion: { in: CONTENT_TYPES }

  validates :endpoint, uniqueness: { scope: %i[client method] }

  validates :delay, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5}

  def render_type
    content_type.split("/").last
  end
end