Rails.application.routes.draw do
  resources :received_mails, only:[:create, :destroy, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/inbox/user/:recipient', to: 'received_mails#getbyuser'
  #get '/inbox/:recipient/sender/:sender', to: 'received_mails#by_sender'
  #get '/inbox/:recipient/read/', to: 'received_mails#read'
  #get '/inbox/:recipient/unread/', to: 'received_mails#unread'
  #get '/inbox/:recipient/urgent/', to: 'received_mails#urgent'
  #get '/inbox/:recipient/not_urgent/', to: 'received_mails#not_urgent'
  get ':username/inbox', to: 'received_mails#index'
  get ':username/inbox/:id', to: 'received_mails#show'

  put ':username/inbox/:id', to: 'received_mails#update'

  delete ':username/inbox/:id', to: 'received_mails#destroy'
end
