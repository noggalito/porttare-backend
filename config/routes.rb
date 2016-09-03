Rails.application.routes.draw do
  root to: redirect("/apipie")
  apipie

  namespace :api, defaults: { format: :json } do
    resources :locations, only: :create
    resources :products, only: :index
    resources :categories, only: :index

    namespace :provider do
      resource :profile, only: :create
      resources :clients,
                only: [:index, :create, :update]
      resources :items,
                only: [:index, :create, :update]
    end

    namespace :auth do
      mount_devise_token_auth_for(
        "User",
        at: "user",
        controllers: {
          sessions: "api/auth/sessions",
          passwords: "api/auth/passwords",
          registrations: "api/auth/registrations",
          omniauth_callbacks: "api/auth/omniauth_callbacks"
          # token_validations: "api/token_validations"
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
