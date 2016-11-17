module Admin
  class ProvidersController < BaseController
    def index
      @current_status = params[:status] || ProviderProfile.status.values.first
      @provider_profiles = providers_scope.with_status(@current_status)
    end

    private

    def authorize_resource
      if pundit_policy.send("#{action_name}?")
        skip_authorization
      else
        raise NotAuthorizedError
      end
    end

    def pundit_policy
      Admin::ProviderProfilePolicy.new(
        pundit_user,
        ProviderProfile
      )
    end

    def providers_scope
      skip_policy_scope
      Admin::ProviderProfilePolicy::Scope.new(
        pundit_user,
        ProviderProfile
      ).resolve
    end
  end
end