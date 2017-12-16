Rails.application.routes.draw do
  root 'pages#index'
  post 'messenger/webhook' => 'messenger#receive_message'
  get '/done' => 'messenger#done'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
