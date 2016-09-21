module Api
  module Courier
    class ProfilesController < BaseController
      resource_description do
        name "Courier::Profiles"
        short "apply for a courier profile"
      end

      before_action :authenticate_api_auth_user!

      api :POST,
          "/courier/profile",
          "Submit a courier profile application. Response includes errors if any."
      param :nombres, String, required: true
      param :ruc, String, required: true
      param :telefono, String, required: true
      param :email, String, required: true
      param :fecha_nacimiento, Date
      param :ubicacion,
            CourierProfile::UBICACIONES
      param :tipo_licencia,
            CourierProfile::TIPOS_LICENCIA
      param :tipo_medio_movilizacion, CourierProfile::TIPOS_MEDIO_MOVILIZACION
      def create
        authorize CourierProfile
        if apply_as_courier?
          head :created
        else
          @errors = @courier_profile.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def apply_as_courier?
        @courier_profile = CourierProfile.new(courier_profile_params)
        @courier_profile.user = current_api_auth_user
        @courier_profile.save
      end

      def courier_profile_params
        params.permit(
          *policy(CourierProfile).permitted_attributes
        )
      end
    end
  end
end
