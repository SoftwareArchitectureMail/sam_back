Rails.application.routes.draw do

  #Login
  get 'refreshtoken', to: 'sessions#refresh_token'
  post 'users/login', to: 'sessions#login'
  delete 'users/logout', to: 'sessions#logout'
  delete 'users/close_all', to: 'sessions#remove_tokens'

  #Usuario
  get 'user', to: 'users#current_user' # < Necesitaba esta :)
  get 'users/check/:username', to: 'users#check_username'
  get 'users', to: 'users#index_user'
  get 'users/:id', to: 'users#show_user'
  put 'users/:id', to: 'users#update_user'
  post 'users/create', to: 'users#create_user'
  delete 'users/:id', to: 'users#destroy_user'


  #SendMail
  get 'sent', to: 'mail#sent'
  get 'sent/:id', to: 'mail#sent_mail'
  get 'draft', to: 'mail#draft_index'
  get 'draft/:id', to: 'mail#draft_show'
  post 'send', to: 'mail#sendMail'
  get 'senddrafts/:id', to: 'mail#send_drafts'
  put 'draft/:id', to: 'mail#modify_draft'
  delete 'sent/:id', to: 'mail#destroy_sent'
  delete 'draft/:id', to: 'mail#destroy_draft'

  #ReceivedMail
  delete 'inbox/:id', to: 'mail#delReceivedMail'
  get 'inbox', to: 'mail#inbox'
  get 'inbox/:id', to: 'mail#received_mail'
  put 'inbox/:id', to: 'mail#update_read'
end
