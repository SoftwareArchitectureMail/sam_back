Rails.application.routes.draw do
  resources :users
  resources :places
  wash_out :check_user
  post 'users/login', to: 'users#login'
  get 'user/:username', to: 'users#show_username'
  get "test", to: 'users#test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.orgroutil
end
