module Moderable
  extend ActiveSupport::Concern
  
  included do
    validate :is_accepted_column_presence
    
    private
    
    def is_accepted_column_presence
      unless self.class.column_names.include?('is_accepted')
        errors.add(:base, "Classes including Moderable must have a column named 'is_accepted'")
      end
    end
  end
  
  def moderating(contents, language)
    require 'net/http'
    require 'uri'
    
    moderations = []
    
    contents.each do |content|
      uri = URI.parse("https://moderation.logora.fr/predict?text=#{URI.encode_www_form_component(content)}&language=#{URI.encode_www_form_component(language)}")
      
      res = Net::HTTP.get_response(uri)
    
      Rails.logger.info "Moderation API response code: #{res.code}"
      Rails.logger.info "Moderation API response body: #{res.body}"
    
      if res.is_a?(Net::HTTPSuccess)
        response_body = JSON.parse(res.body)
        moderations << response_body
      else
        Rails.logger.error "Error moderating content: #{res.message}"
        moderations << false
      end
    rescue StandardError => e
      Rails.logger.error "Error moderating content: #{e.message}"
      moderations << false
    end
    
    return moderations
  end
  


  def attributes_to_moderate
    raise NotImplementedError, 'attributes_to_moderate doit être implementée dans la classe'
  end
end
