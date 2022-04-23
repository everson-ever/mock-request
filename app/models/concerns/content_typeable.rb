module ContentTypeable
  extend ActiveSupport::Concern

  def content_type_json?
    content_type == "application/json"
  end

  def content_type_xml?
    content_type == "application/xml"
  end

  def text_plain?
    content_type == "text/plain"
  end

  def response_to_json
    response_body.to_json
  end

  def response_to_xml
    begin
      Nokogiri::XML(response_body) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError => e
      self.errors.add(:response_body, "This is not a valid xml")
    end
  end

  def response_to_text
    response_body.to_s
  end
end
