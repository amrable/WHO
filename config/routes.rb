Rails.application.routes.draw do
  get 'home/about_us'
  get '/download_pdf/:uuid', to: "identities#download_pdf"
  get '/identities/new', to:'identities#new'
  get '/identities/:uuid/edit', to:'identities#edit'
  get '/identities/s/:uuid', to: 'identities#select'
  resources :identities,  :except => [:show, :destroy, :index]
  root to: "identities#new"
  get '/about_us', to: 'home#about_us'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
