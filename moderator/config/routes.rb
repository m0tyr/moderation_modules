Rails.application.routes.draw do
  root 'moderation#index'
  post 'predict_moderation', to: 'moderation#predict'
  get 'content_moderation', to: 'moderation#content_moderation'

end
