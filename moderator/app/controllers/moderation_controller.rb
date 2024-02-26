class ModerationController < ApplicationController
  def index
  end
  def content_moderation
    if request.get?
      language = 'fr-FR'
      section1_content = params[:section1_content]
      section2_content = params[:section2_content]
      section3_content = params[:section3_content]
      Rails.logger.info "#{section1_content}"
      Rails.logger.info "#{section2_content}"
      Rails.logger.info "#{section3_content}"
      contents = [section1_content,section2_content,section3_content]
      moderated_model = ModerationModels.new
      predictions = moderated_model.moderating(contents, language)
      Rails.logger.info "#{predictions}"
      predictions.each_with_index do |prediction, index|
        flash["prediction_#{index}"] = prediction["prediction"]["0"]
      end
    else
      redirect_to content_moderation_path
    end
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
