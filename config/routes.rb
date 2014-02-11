BoogieListApp::Application.routes.draw do

  root :to => "home#login"
  
  resources :posts do
    member do
      get :add_to_playlist
      get :remove_from_playlist
      get :set_current_playlist
    end
  end
  
  resources :imports do
    member do
      get :run
    end
  end

  resources :playlists
  resources :users
   
  resources :playlist_posts
  resources :playlist_users

  get "home/callback", to: "home#callback"
  get "/users", to: "users#index"
  get "/playlists", to: "playlists#index"
  
  # get "posts/empty_db" => "posts#empty_db"
  # get "/you2mp3/(food)", to: "you2mp3#food"
  
end
