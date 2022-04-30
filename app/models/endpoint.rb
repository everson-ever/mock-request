# frozen_string_literal: true

class Endpoint < ApplicationRecord
  include ContentTypeable

  METHODS = %w[GET POST PUT DELETE].freeze
  CONTENT_TYPES = %w[application/json application/xml text/plain].freeze

  belongs_to :client

  before_validation :response_to_json, if: :content_type_json?
  before_validation :response_to_xml,  if: :content_type_xml?
  before_validation :response_to_text, if: :text_plain?

  before_create :remove_slash_from_endpoint

  validates :endpoint, :request_method, :content_type,
    :client, presence: true

  validates :request_method, inclusion: { in: METHODS }
  validates :content_type, inclusion: { in: CONTENT_TYPES }

  validates :endpoint, uniqueness: { scope: %i[client_id request_method] }

  validates :delay, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }

  def render_type
    content_type.split("/").last.to_sym
  end

  private

  def remove_slash_from_endpoint
    return unless endpoint.first == "/"

    endpoint.slice!("/")
  end
end
