Rails.application.routes.draw do
  root 'public#index'
  get 'dashboard', to: 'dashboard#index'
  post 'dashboard', to: 'dashboard#create'
  get 'products', to: 'products#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
