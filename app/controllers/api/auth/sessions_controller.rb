module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      extend BaseDoc
      include DeviseTokenAuth::Concerns::SetUserByToken
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        short "user session"
        description "sessions handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :sign_in do
        api :POST,
            "/auth/user/sign_in",
            "login"
        description "authenticate using email and password. Response includes user's content preferences"
        param :email, String, required: true
        param :password, String, required: true
      end

      doc_for :sign_out do
        api :DELETE,
            "/auth/user/sign_out",
            "log out"
        description "aka end session"
      end
    end
  end
end
