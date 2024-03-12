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
  resources :users
  resources :sessions, except: [:destroy] do
    collection do
      delete :destroy
    end
  end
end
