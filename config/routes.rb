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
      namespace :cart do
        root to: 'items#index'
        resources :items,
                  only: [:create, :update, :destroy]
        resource :checkout,
                 only: :create
      end
      resources :wishlists,
                only: [:index, :create, :update, :destroy]
      resources :addresses,
                only: [:index, :create, :update]
      resources :billing_addresses,
                only: [:index, :create, :update]
    end

    namespace :provider do
      resource :profile,
               only: [:create, :update]
      resources :items,
                only: [:index, :show, :create, :update, :destroy]
      resources :offices,
                only: [:index, :show, :create, :update]#, :destroy]
      resources :clients,
                only: [:index, :create, :update, :destroy]
      resources :dispatchers,
                only: [:index, :show, :create, :update, :destroy]
      resources :item_categories,
                only: [:index]
    end

    namespace :courier do
      resource :profile, only: :create
      resources :shipping_requests, only: :index
    end

    namespace :users do
      resource :tos,
               only: :create
      resource :account,
               only: [:show, :update]
    end

    namespace :auth do
      resource :native_login, only: :create
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
    resources :users do
      collection do
        get "/by_status/:status",
            to: "users#index",
            as: :by_status
      end
    end
    resources :shipping_requests
    resources :providers do
      collection do
        get "/by_status/:status",
            to: "providers#index",
            as: :by_status
      end
      member do
        post "/transition/:predicate",
             to: "providers#transition",
             as: :transition
      end
    end
    root "providers#index"
  end
end
