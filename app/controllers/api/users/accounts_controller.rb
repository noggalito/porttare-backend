module Api
  module Users
    class AccountsController < BaseController
      resource_description do
        name "User::Accounts"
        short "user's account"
      end

      before_action :authenticate_api_auth_user!
      before_action :authorize_user!

      api :GET,
          "/users/account",
          "get User's account"
      example %q{{
  "user":{
    "id":2,
    "name":"Ana María Cornejo Vásquez",
    "email":"darlene@collierfranecki.biz",
    "ciudad":"Móstoles",
    "fecha_nacimiento":"1973-08-06"
  }
}}
      def show
      end

      api :PUT,
          "/users/account",
          "Update user account"
      param :name, String
      param :email, String
      param :ciudad, String
      param :fecha_nacimiento, Date
      param :password, String, "if you want to update your account's password"
      def update
        if @user.update(user_params)
          render :show, status: :accepted
        else
          @errors = @user.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def user_params
        attributes = if params[:password].present?
          policy(User).permitted_attributes_with_password
        else
          policy(User).permitted_attributes
        end
        params.permit(attributes)
      end

      def authorize_user!
        authorize User
        @user = policy_scope(User)
      end
    end
  end
end
