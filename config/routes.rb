Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    resources :products
    resources :carts
    resources :orders
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    namespace :admins do
      post "/products/get_products_active", to: "products#get_products_active"
      root to: "products#index"
      resources :products
      resources :orders
      resources :users
    end
  end
end
