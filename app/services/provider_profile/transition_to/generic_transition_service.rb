class ProviderProfile < ActiveRecord::Base
  module TransitionTo
    class GenericTransitionService
      delegate :transaction, to: :@provider_profile

      def initialize(provider_profile)
        @provider_profile = provider_profile
      end

      def flashes
        if valid?
          {
            success: I18n.t(
              "admin.provider_profile.transition.to.#{predicate}"
            )
          }
        else
          {
            error: I18n.t("admin.something_went_wrong") + ": " + errors.join(", ")
          }
        end
      end

      def valid?
        if errors.empty?
          perform_validations!
        end
        errors.empty?
      end

      private

      def errors
        @errors ||= []
      end

      def update_state!
        @provider_profile.paper_trail_event = predicate
        @provider_profile.update!(status: predicate)
      end
    end
  end
end
