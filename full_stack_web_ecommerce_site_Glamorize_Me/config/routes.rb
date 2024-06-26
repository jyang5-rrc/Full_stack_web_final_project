Rails.application.routes.draw do

  root 'home#index'
  get 'home', to: 'home#index'

  devise_for :users
  devise_for :administrators, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)


  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'categories', to: 'categories#categories', as: 'categories'
  get 'brands', to: 'brands#brands', as: 'brands'
  get 'product_tpyes', to: 'product_types#product_types', as: 'product_types'
  get 'search', to: 'products#search', as: 'search'
  get 'products/:id', to: 'products#show', as: 'product'

  # define routes for the categories controller that are nested under the categories resource
  # /categories/:id/show_products
  # resources :categories do
  #   member do
  #     get 'show_products'
  #   end
  # end
  resources :categories do
    get 'show_products', on: :member
  end

  resources :brands do
    member do
      get 'show_products'
    end
  end

  resources :product_types do
    member do
      get :show_products
    end
  end


  resource :cart, only: [:show, :update, :destroy]
  resources :cart_items, only: [:create, :update, :destroy]

  resources :cart_items do
    collection do
      delete 'remove_product/:product_id', to: 'cart_items#remove_product', as: 'remove_product'
    end
  end

  resources :orders do
    member do
      get :checkout
    end
  end






  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
