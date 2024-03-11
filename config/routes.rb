Rails.application.routes.draw do
  resources :static_pages, only: [] do
    collection do
      get :home
      get :help
      get :about
    end
  end
end
