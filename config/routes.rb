Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'
  resources :shipments do
    get 'search', action: 'search', on: :collection
  end

  namespace :deposit do
    root 'home#index'
    get 'search', to: 'shipments#show'
  end

  namespace :admin do
    root 'home#index'
    get  'sales', to: 'sales#report'
    resources :shipments, only: [:edit, :update]
  end

  namespace :api do
    get '/login', to: 'sessions#create'

    resources :shipments, only: [:index] do
      get 'search', action: 'search', on: :collection
    end

    namespace :deposit do
      get 'search', to: 'shipments#search'
    end
    
  end

end

