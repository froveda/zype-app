Rails.application.routes.draw do
  resources :sessions, only: [:new, :create] do
    collection do
      delete :logout
      get :login_fail
    end
  end

  resources :videos, only: [:index, :show]

  root to: "home#index"
end
