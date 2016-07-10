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

      # HACK
      # taken from github to make it work
      # https://github.com/lynndylanhurley/devise_token_auth/blob/1d6dbdc2e5ba2de00264362a8a876dc98585bd0c/app/controllers/devise_token_auth/omniauth_callbacks_controller.rb
      # intermediary route for successful omniauth authentication. omniauth does
      # not support multiple models, so we must resort to this terrible hack.
      def redirect_callbacks
        # derive target redirect route from 'resource_class' param, which was set
        # before authentication.
        devise_mapping = Devise.mappings[:api_auth_user]
        redirect_route = "#{request.protocol}#{request.host_with_port}/#{devise_mapping.fullpath}/#{params[:provider]}/callback"

        # preserve omniauth info for success route. ignore 'extra' in twitter
        # auth response to avoid CookieOverflow.
        session['dta.omniauth.auth'] = request.env['omniauth.auth'].except('extra')
        session['dta.omniauth.params'] = request.env['omniauth.params']

        redirect_to redirect_route
      rescue NoMethodError
        # TODO handle better
        # this is likely to happen
        # on an oauth failure
        redirect_to(
          omniauth_failure_path(message: params[:error_message])
        )
      end
    end
  end
end
