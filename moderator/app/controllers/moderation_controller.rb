class ModerationController < ApplicationController
  def index
  end
  def content_moderation
  end
  
  def predict
    texts = params[:texts].values.map { |text| text[:text] } || []
    language = params[:language]
    Rails.logger.info "text array value: #{texts}"

    moderated_model = ModerationModels.new
    predictions = moderated_model.moderating(texts, language)
    
    sum_of_predictions = predictions.inject(0) do |sum, prediction|
      prediction_value = prediction["prediction"]["0"]
      Rails.logger.info "Prediction value: #{prediction_value}"
      sum + prediction_value.to_f 
    end
    
    average_prediction = sum_of_predictions / predictions.length.to_f
    
    Rails.logger.info "Average prediction value: #{average_prediction}"
  
    redirect_to root_path, flash: { prediction: average_prediction }
  end
end
