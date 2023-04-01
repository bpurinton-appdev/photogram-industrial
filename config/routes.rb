Rails.application.routes.draw do
  root to: "photos#index"
  
  devise_for :users

  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  get ":username/liked" => "photos#liked", as: :liked_photos

  # get "/users/:id" => "users#show", as: :user
  # resources :users, only: [:show, :update]
  # resources :users, only: :show
  get "/:username" => "users#show", as: :user

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
