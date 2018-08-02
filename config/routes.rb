Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "sessions/new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  namespace :admin do
    resources :movies
  end
  resources :movies, only: [:searchs] do
    collection do
      resources :searchs, only: [:index, :create]
    end
  end
  resources :account_activations, only: [:edit]


  resources :rooms, only: [:show]

end
