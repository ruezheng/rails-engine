Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, module: 'merchants', only: [:index]
      end
      resources :items, only: [:index, :show, :new, :create, :update, :destroy]
    end
  end
end
