Rails.application.routes.draw do
  root to: redirect("/apipie")
  apipie

  namespace :api, defaults: { format: :json } do
    resources :locations, only: :create
    resources :products, only: :index
    resources :categories, only: :index do
      resources :providers, only: [:index, :show]
    end

    namespace :customer do
      resource :cart,
               controller: :cart,
               only: [:create]
    end

    namespace :provider do
      resource :profile, only: :create
      resources :clients,
                only: [:index, :create, :update, :destroy]
      resources :items,
                only: [:index, :create, :update, :destroy]
      resources :dispatchers,
                only: [:index, :create, :update, :destroy]
    end

    namespace :courier do
      resource :profile, only: :create
    end

    namespace :auth do
      mount_devise_token_auth_for(
        "User",
        at: "user",
        controllers: {
          sessions: "api/auth/sessions",
          passwords: "api/auth/passwords",
          registrations: "api/auth/registrations",
          token_validations: "api/auth/token_validations",
          omniauth_callbacks: "api/auth/omniauth_callbacks"
        }
      )
    end
  end

  devise_for :admins,
             path: "admin",
             class_name: "User",
             skip: [
               :registrations,
               :passwords
             ]
  namespace :admin do
    resources :users
    root "users#index"
  end
end
