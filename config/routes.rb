Rails.application.routes.draw do
  get "/login" => redirect("/users/sign_in")

  get '/' => redirect("/home")

  require 'sidekiq/web'
  
  if Rails.env == 'production'
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  else
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users

  resources :home, except: [:new, :create, :index, :destroy] do
    root :to => 'home#home'
    collection do
      get 'home'

      post 'tweet'
    end  
  end
  resources :relationships , :only => [:create, :destroy]

  resources :search , :only => [:index] 
end
