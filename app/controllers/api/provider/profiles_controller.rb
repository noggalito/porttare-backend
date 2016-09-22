module Api
  module Provider
    class ProfilesController < BaseController
      resource_description do
        name "Provider::Profiles"
        short "apply for a provider profile"
      end

      before_action :authenticate_api_auth_user!

      api :POST,
          "/provider/profile",
          "Submit a provider profile application. Response includes the errors if any."
      param :ruc, String, required: true
      param :razon_social, String, required: true
      param :nombre_establecimiento,
            String,
            required: true,
            desc: "AKA. _nombre comercial_"
      param :actividad_economica, String
      param :representante_legal, String, required: true
      param :telefono, String, required: true
      param :email, String, required: true
      param :website, String
      param :forma_de_pago,
            Array,
            in: ProviderProfile::FORMAS_DE_PAGO,
            desc: "an array of options. options must be within: #{ProviderProfile::FORMAS_DE_PAGO.join(", ")}"
      param :logotipo, File
      param :banco_nombre, String
      param :banco_numero_cuenta, String
      param :banco_tipo_cuenta, ProviderProfile::BANCO_TIPOS_CUENTA
      param :offices_attributes,
            Hash,
            desc: "provider's offices (branches)" do
        param :direccion,
              String,
              required: true,
              desc: "Branches without `direccion` will be ignored"
        param :horario,
              String,
              required: true
      end
      param :facebook_handle, String
      param :twitter_handle, String
      param :instagram_handle, String
      param :youtube_handle, String
      example %q{{
  "provider_profile":{
    "id":3,
    "ruc":"5184135690",
    "razon_social":"Bernal e Hijos",
    "nombre_establecimiento":"Ballesteros y Sosa",
    "actividad_economica":"writer",
    "representante_legal":"Rebeca Regalado Espinal",
    "telefono":"948075420",
    "email":"benedict_heel@predovicjacobson.name",
    "website":"http://mann.net/harmon_hartmann",
    "formas_de_pago":["tarjeta_credito"],
    "logotipo_url":null,
    "facebook_handle":"savannah",
    "twitter_handle":"noah.beier",
    "instagram_handle":"keegan.wehner",
    "youtube_handle":"matteo_bashirian",
    "banco_nombre":"Principado de Asturias crows",
    "banco_numero_cuenta":"90-5771199",
    "banco_tipo_cuenta":"Crédito",
    "offices":[{
      "id":1,
      "direccion":"Extramuros Jorge Yáñez 2",
      "ciudad":"Ávila",
      "horario":"09:00-18:00",
      "enabled":false
    }]
  }
}}
      def create
        authorize ProviderProfile
        if apply_as_provider?
          render "api/provider/profiles/create",
                 status: :created
        else
          @errors = @provider_profile.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def apply_as_provider?
        @provider_profile = ProviderProfile.new(provider_profile_params)
        @provider_profile.user = current_api_auth_user
        @provider_profile.save
      end

      def provider_profile_params
        params.permit(
          *policy(ProviderProfile).permitted_attributes
        )
      end
    end
  end
end
