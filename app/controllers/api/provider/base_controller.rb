module Api
  module Provider
    class BaseController < Api::BaseController
      before_action :verify_provider_is_active

      protected

      def verify_provider_is_active
        provider_profile = pundit_user.provider_profile
        if !provider_profile.present? || provider_profile.status.disabled?
          raise Pundit::NotAuthorizedError.new(
            t("provider_profile.errors.disabled")
          )
        end
      end
    end
  end
end
