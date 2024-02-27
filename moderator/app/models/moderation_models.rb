class ModerationModels < ApplicationRecord
  include Moderable
  
  def attributes_to_moderate
    [:content, :language]
  end
  
  def moderate_attributes(text, language)
    language = "fr-FR"
    is_accepted = moderating(text, language)
    { text: text, language: language, prediction: is_accepted }
  end
end
