module Api
  module Provider
    class ProfilesController < BaseController
      resource_description do
        name "Provider::ProfilesController"
        short "apply for a provider profile"
      end

      api :POST,
          "/provider/profile",
          "Submit a provider profile application. Response includes the errors if any."
      param :ruc, String, required: true
      param :razon_social, String, required: true
      param :actividad_economica, String, required: true
      param :tipo_contribuyente, String
      param :representante_legal, String
      param :telefono, String, required: true
      param :email, String, required: true
      param :fecha_inicio_actividad, Date
      param :banco_nombre, String, required: true
      param :banco_numero_cuenta, String, required: true
      param :banco_identificacion, String, required: true
      param :website, String
      param :facebook_handle, String
      param :twitter_handle, String
      param :instagram_handle, String
      param :youtube_handle, String
      param :mejor_articulo, String
      param :forma_de_pago,
            String,
            desc: "an array of options. options must be within: #{ProviderProfile::FORMAS_DE_PAGO.join(", ")}"
      def create
        authorize ProviderProfile
        if apply_as_provider!
          render nothing: true, status: :created
        else
          render :create_error, status: :unprocessable_entity
        end
      end

      private

      def apply_as_provider!
        @provider_profile = ProviderProfile.new(provider_profile_params)
        @provider_profile.user = current_api_auth_user
        @provider_profile.save
      end

      def provider_profile_params
        params.permit(
          :ruc,
          :razon_social,
          :actividad_economica,
          :tipo_contribuyente,
          :representante_legal,
          :telefono,
          :email,
          :fecha_inicio_actividad,
          :banco_nombre,
          :banco_numero_cuenta,
          :banco_identificacion,
          :website,
          :facebook_handle,
          :twitter_handle,
          :instagram_handle,
          :youtube_handle,
          :mejor_articulo,
          formas_de_pago: []
        )
      end
    end
  end
end
