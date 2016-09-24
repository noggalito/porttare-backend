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
      param :ruc, String, required: true
      param :email, String, required: true
      param :nombres, String, required: true
      param :telefono, String, required: true
      param :fecha_nacimiento, Date
      param :ubicacion,
            CourierProfile::UBICACIONES
      param :tipo_licencia,
            CourierProfile::TIPOS_LICENCIA
      param :tipo_medio_movilizacion, CourierProfile::TIPOS_MEDIO_MOVILIZACION
      example %q{{
  "courier_profile":{
    "id":1,
    "ruc":"1014736509",
    "email":"raina_lockman@schoen.io",
    "nombres":"Sr. María Cristina Pabón Mireles",
    "telefono":"988295716",
    "fecha_nacimiento":"1966-02-27",
    "ubicacion":"Loja",
    "tipo_licencia":"D1",
    "tipo_medio_movilizacion":"Bus pasajeros"
  }
}}
      def create
        authorize CourierProfile
        if apply_as_courier?
          render "api/courier/profiles/create",
                 status: :created
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
