Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  get  'auth/:provider/callback' => 'sessions#create'
  post 'logout' => 'sessions#destroy'
  get  'auth/failure' => 'sessions#failure'
  get  'auth/twitter', :as => 'login'
  post '/movies/search_tmdb'

  resources :movies do
    resources :reviews
  end
  root :to => redirect('/movies')

end

