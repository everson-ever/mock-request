# frozen_string_literal: true

module ContentTypeable
  extend ActiveSupport::Concern

  def content_type_json?
    content_type == "application/json" && response_body.present?
  end

  def content_type_xml?
    content_type == "application/xml" && response_body.present?
  end

  def text_plain?
    content_type == "text/plain" && response_body.present?
  end

  def response_to_json
    response_body.to_json
  end

  def response_to_xml
    Nokogiri::XML(response_body, &:strict)
  rescue Nokogiri::XML::SyntaxError
    errors.add(:response_body, "This is not a valid xml")
  end

  def response_to_text
    response_body.to_s
  end
end
