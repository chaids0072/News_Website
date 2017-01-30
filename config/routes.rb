Rails.application.routes.draw do

  # Root is the unauthenticated path
  root 'sessions#unauth'

  # Sessions URL
  get 'sessions/unauth', to: 'sessions#unauth', as: :login
  post 'sessions/login', as: :signin
  delete 'sessions/logout', as: :logout

  get '/scrape', to: 'articles#refresh', as: :scrape_news

  # Resourceful routes for posts
  resources :articles
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user
  
  get 'interests', to: 'articles#my_interests', as: :interest
  resources :users, only: [:create,:new,:update,:destroy,:edit]
end
