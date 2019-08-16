Rails.application.routes.draw do
  resources :municipalities
  get 'municipalities_list', to: 'municipalities#list', as: 'municipalities_by_department'
  resources :departments
  resources :pieces
  resources :villages
  get 'villages_list', to: 'villages#list', as: 'villages_by_municipality'
  resources :deliveries
  resources :parameters
  resources :transactions do
    resources :transaction_details
    post 'close_order', to: 'close_order', as: 'close_order'
    post 'change_status', to: 'change_status', as: 'change_status'
    post 'devolucion', to: 'devolucion', as: 'devolucion'
    post 'not_delivery', to: 'not_delivery', as: 'not_delivery'
    get '/view_tracking', to: 'transactions#view_tracking', as: 'view_tracking'
    post '/return_stock', to: 'transactions#return_to_stock', as: 'return_to_stock'
  end
  get '/delivered', to: 'transactions#delivered', as: 'delivered'
  get '/pendings', to: 'transactions#pendings', as: 'pendings'
  get '/pendings_not', to: 'transactions#pendings_not', as: 'pendings_not_delivered'
  get '/on_route', to: 'transactions#on_route', as: 'on_route'
  post '/asign_courier', to: 'transactions#asign_courier', as: 'asign_courier'
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

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'product_availability', to: 'inventory_utils#check_inventory_qty', as: 'product_availability'
    end
  end

  root 'dashboard#index'
end
