Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, controllers: {omniauth_callbacks: :omniauth_callbacks}
  root "users#show"

  resources :users, only: [:show, :new]
  resources :user_avatars, only: :create
  resource :user_avatars, only: :update

  resources :user_covers, only: :create
  resource :user_covers, only: :update
  resources :friend_ships, only: [:create, :destroy, :update]
  resources :info_users, only: :update
  resources :user_portfolios, except: [:index, :show]
  resources :awards, except: [:index, :show]
  resources :user_works, except: :show
  resources :user_educations, except: :show
  resources :user_links, except: [:show, :index]
  resources :user_posts do
    resources :comments, except: [:show, :new, :index]
    resources :likes, only: [:create, :destroy]
  end
  resources :user_projects, except: [:index, :show]
  resources :certificates, except: [:index, :show]
  resources :user_languages, except: :show
  resources :user_social_networks, only: :create
  resource :user_social_networks, only: :update
  resources :user_languages
  resources :organizations, only: :show
  resources :articles, only: :show
  resources :friend_requests, only: :index
  resources :skill_users
  resources :messages
  resources :skills, only: :index
end
