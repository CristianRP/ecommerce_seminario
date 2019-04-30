Rails.application.routes.draw do
  resources :parameters
  resources :transactions do 
    resources :transaction_details
    post 'close_order', to: 'close_order', as: 'close_order'
  end
  resources :products
  devise_for :dealers, controllers: {
    sessions: 'dealers/sessions'
  }
  resources :statuses
  resources :carriers
  resources :characteristics
  resources :categories
  resources :dealers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'dashboard#index'
end
