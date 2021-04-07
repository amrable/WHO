Rails.application.routes.draw do
  get '/download_pdf/:uuid', to: "identities#download_pdf"
  get '/identities/new', to:'identities#new'
  get '/identities/s/:uuid', to: 'identities#select'
  resources :identities,  :except => [:show, :index, :destroy, :edit, :update]
  root to: "identities#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
