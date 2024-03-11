Rails.application.routes.draw do
  resources :static_pages, only: [] do
    collection do
      get :home
      get :help
      get :about
      get :contact
    end
  end
  resources :users
end
