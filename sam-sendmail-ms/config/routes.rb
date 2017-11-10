Rails.application.routes.draw do
  #resources :sent_mails

  get 'sent', to: 'sent_mails#index'
  get 'sent/:id', to: 'sent_mails#show'
  get 'draft', to: 'sent_mails#draft_index'
  get 'draft/:id', to: 'sent_mails#draft_show'

  post 'sent', to: 'sent_mails#create'

  put 'sentdraft/:id',to:'sent_mails#modify_draft'
  put 'draft/:id', to: 'sent_mails#sent_draft'

  delete 'draft/:id', to: 'sent_mails#delDraft'
  delete 'sent/:id', to: 'sent_mails#destroy'

end
