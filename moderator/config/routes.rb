Rails.application.routes.draw do
  root 'moderation#index'
  post 'predict_moderation', to: 'moderated#attributes_to_moderate'
end
