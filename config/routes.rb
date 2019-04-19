Rails.application.routes.draw do
  resources :statuses
  resources :carriers
  resources :characteristics
  resources :categories
  resources :dealers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#index'
end
