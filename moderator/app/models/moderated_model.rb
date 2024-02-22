class ModeratedModel < ApplicationRecord
  include Moderable
  
  def attributes_to_moderate
    [:content, :language]
  end
  
  before_save :moderate_attributes
  
  private
  
  def moderate_attributes
    attributes_to_moderate.each do |attribute|
      content = send(attribute)
      language = 'fr' 
      is_accepted = moderating(content, language)
      self.is_accepted = is_accepted
    end
  end
end