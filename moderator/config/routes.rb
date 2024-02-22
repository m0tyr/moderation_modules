Rails.application.routes.draw do
  root 'moderation#index'
  post 'predict_moderation', to: 'moderation#predict'
end