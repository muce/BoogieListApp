BoogieListApp::Application.routes.draw do
  
  resources :posts

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

end
