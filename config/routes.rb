require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :stocks, param: :code do
      get 'my', on: :member
      post 'select', on: :member
      post 'deselect', on: :member
      get 'holding_rank', on: :member
    end

    resources :users do
      post 'login', on: :collection
      post 'logout', on: :collection
    end
    get 'user', to: 'users#show'
    get 'profile', to: 'profile#show'

    resources :wishs, only: [:index, :create]
    resources :super_wishs, only: [:index, :create]

    resources :orders, only: [:index, :create] do
      post 'cancel', on: :member
      get 'my', on: :collection
    end

    resources :deals do
      get 'my', on: :collection
    end
    resources :trends

    get 'geetest', to: 'geetest#new'

    get 'rank', to: 'rank#index'
  end

  mount Sidekiq::Web => '/sidekiq'
end
