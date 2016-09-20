module Api
  module Auth
    class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        short "authenticate users using oauth"
        description "oauth handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :redirect_callbacks do
        api :GET,
            "/auth/user/:provider",
            "authorise a user using specified provider"
        param :provider, String, required: true
        param :auth_origin_url, String, required: true
      end

      protected

      # HACK
      # taken from github to make it work
      # https://github.com/lynndylanhurley/devise_token_auth/blob/1d6dbdc2e5ba2de00264362a8a876dc98585bd0c/app/controllers/devise_token_auth/omniauth_callbacks_controller.rb
      def resource_class
        User
      end

      def devise_mapping
        request.env['devise.mapping']
      end

      def auth_hash
        request.env['omniauth.auth']
      end
    end
  end
end
