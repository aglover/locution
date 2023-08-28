Rails.application.routes.draw do
  root "words#index"

  # get "/words", to: "words#index"
  # get "/words/:id", to: "words#show"
  resources :words do
    resources :definitions
  end

  namespace :api do
    resources :words, :defaults => { :format => "json" }, :only => [:create, :index, :show]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
