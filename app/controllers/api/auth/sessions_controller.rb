module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::Sessions"
        short "user session"
        description "sessions handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :sign_in do
        api :POST,
            "/auth/user/sign_in",
            "login"
        description "authenticate using email and password"
        param :email, String, required: true
        param :password, String, required: true
        example %q{{
  "data": {
      "id":1,
      "provider":"email",
      "uid":"user-1@noggalito.com",
      "name":null,
      "nickname":null,
      "image":null,
      "email":"user-1@noggalito.com",
      "info":null,
      "credentials":null,
      "provider_profile_id":1
  }
}}
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
