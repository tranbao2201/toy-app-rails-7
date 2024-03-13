Rails.application.routes.draw do
  root "static_pages#home"
  resources :static_pages, only: [] do
    collection do
      get :home
      get :help
      get :about
      get :contact
    end
  end
  resources :users do
    member do
      get :followings, :followers
    end
  end
  resources :sessions, except: [:destroy] do
    collection do
      delete :destroy
    end
  end
  resource :account_activations, only: [:edit]
  resource :reset_passwords
  resources :microposts
  resources :relationships
end
