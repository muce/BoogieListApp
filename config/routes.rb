BoogieListApp::Application.routes.draw do
  
  resources :playlist_posts

  resources :posts do
    member do
      get :add_to_playlist
      get :set_current_playlist
      get :empty_db
      get :import_from_db
    end
  end

  resources :playlist_songs

  resources :playlist_users

  resources :songs

  resources :playlists

  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => "home#index"

  get "home/callback", to: "home#callback"
  
  get "/songs", to: "songs#index"
  get "/users", to: "users#index"
  get "/playlists", to: "playlists#index"

  # put "posts/add_to_playlist" => "posts#add_to_playlist"
  # get "posts/set_current_playlist" => "posts#set_current_playlist"
  # get "posts/empty_db" => "posts#empty_db"
  
  # get "/you2mp3/(food)", to: "you2mp3#food"
  
end
