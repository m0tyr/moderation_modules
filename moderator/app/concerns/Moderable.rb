module Moderable
    extend ActiveSupport::Concern
    
    def moderating(content, language)
        uri = URI('https://moderation.logora.fr/predict')
        req = Net::HTTP::Post.new(uri)
        req.body = { text: content, language: language }.to_json
        req['Content-Type'] = 'application/json'
      
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end
      
        res.is_a?(Net::HTTPSuccess) && JSON.parse(res.body)['is_accepted']
      rescue StandardError => e
        Rails.logger.error "Error moderating content: #{e.message}"
        false
      end

    def attributes_to_moderate
        raise NotImplementedError, 'attributes_to_moderate doit être implementée dans la classe'
    end
end
  