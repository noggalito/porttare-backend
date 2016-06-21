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
    end
  end
end
