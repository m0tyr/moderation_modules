class ModerationController < ApplicationController
    include ModeratedModel
    def index
    end
  
    def predict
      text = params[:text]
      language = params[:language]
  
      result = ModeratedModel.new.attributes_to_moderate(text, language)

      render json: { prediction: result }
    end
  end