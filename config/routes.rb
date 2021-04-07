Rails.application.routes.draw do
  get '/identities/new', to:'identities#new'
  get '/identities/s/:uuid', to: 'identities#select'
  resources :identities 
  root to: "identities#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
