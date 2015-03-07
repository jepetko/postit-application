PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  #get '/posts', to: 'posts#index'
  #get '/posts/:id', to: 'posts#show'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end

  resources :categories, only: [:new, :create, :show]

  resources :users, only: [:new, :create]
end
