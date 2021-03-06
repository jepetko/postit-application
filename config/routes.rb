PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  #get '/posts', to: 'posts#index'
  #get '/posts/:id', to: 'posts#show'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/pin', to: 'sessions#pin'
  post '/pin', to: 'sessions#pin'

  resources :posts, except: [:destroy] do

    #/posts/1/vote
    member do
      post :upvote, to: :vote, defaults: {vote: true}
      post :downvote, to: :vote, defaults: {vote: false}
    end

    #/posts/archives
    #collection => no id!!!
    #collection do
    #  get :archives
    #end

    resources :comments, only: [:create] do
      member do
        post :upvote, to: :vote, defaults: {vote: true}
        post :downvote, to: :vote, defaults: {vote: false}
      end
    end
  end

  resources :categories, only: [:new, :create, :show]

  resources :users, only: [:new, :create, :show, :edit, :update]

  # disadvantage: we nee additional information
  #resources :votes, only: [:create]
end
