module Api
  module Auth
    class NativeLoginsController < DeviseTokenAuth::OmniauthCallbacksController
      resource_description do
        name "Auth::NativeLogins"
        short "login via oauth in devices"
      end

      def create
        if params[:provider] == "facebook"
          create_from_facebook!
          render "api/auth/sessions/user"
        end
      end

      private

      def create_from_facebook!
        get_resource_from_auth_hash
        create_token_info
        set_token_on_resource
        create_auth_params

        if User.devise_modules.include?(:confirmable)
          @resource.skip_confirmation! # don't send confirmation email
        end

        sign_in(:user, @resource, store: false, bypass: false)

        @resource.save!
      end

      def auth_hash
        @auth_hash ||= fb_api_profile
      end

      def fb_api_profile
        koala = Koala::Facebook::API.new(
          params[:access_token],
          Rails.application.secrets.facebook_secret
        )
        koala.get_object("me", fields: fb_fields.join(","))
      end

      def get_resource_from_auth_hash
        @resource = User.where(
          uid: auth_hash['id'],
          provider: params[:provider]
        ).first_or_initialize

        if @resource.new_record?
          @oauth_registration = true
          set_random_password
        end

        assign_provider_attrs(@resource, auth_hash)

        @resource
      end

      def assign_provider_attrs(user, auth_hash)
        user.assign_attributes({
          name:             auth_hash['name'],
          email:            auth_hash['email'],
          fecha_nacimiento: auth_hash['birthday'],
          image:            auth_hash['picture']['data']['url']
        })
      end

      def fb_fields
        %w(
          id
          name
          email
          birthday
          picture{url}
        )
      end
    end
  end
end
