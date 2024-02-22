class ModerationController < ApplicationController
  def index
  end
  
  def predict
    text = params[:text]
    language = params[:language]
  
    moderated_model = ModeratedModel.new
    result = moderated_model.moderating(text, language)
  
    render json: { prediction: result }
  end
end