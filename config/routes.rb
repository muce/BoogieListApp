BoogieListApp::Application.routes.draw do

  root :to => "posts#index"

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', :as => :signout
  get '/signin', to:  'sessions#new', :as => :signin
   
  resources :playlist_posts

  resources :posts do
    member do
      get :add_to_playlist
      get :remove_from_playlist
      get :set_current_playlist
      get :empty_db
      get :import_from_db
    end
  end
  
  resources :imports do
    member do
      get :run
    end
  end

  resources :playlists
  resources :users

  get "home/callback", to: "home#callback"
  get "/users", to: "users#index"
  get "/playlists", to: "playlists#index"
  
  # get "posts/empty_db" => "posts#empty_db"
  # get "/you2mp3/(food)", to: "you2mp3#food"
  
end
