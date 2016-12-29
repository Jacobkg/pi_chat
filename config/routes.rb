Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  get 'chat/index'

  root 'chat#index'
end
