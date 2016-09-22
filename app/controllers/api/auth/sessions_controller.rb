module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      extend BaseDoc
      include BaseController::JsonRequestsForgeryBypass

      resource_description do
        name "Auth::Sessions"
        short "user session"
        description "sessions handled by [`devise_token_auth` gem](https://github.com/lynndylanhurley/devise_token_auth)"
      end

      doc_for :sign_in do
        api :POST,
            "/auth/user/sign_in",
            "login"
        description "authenticate using email and password. Response includes full provider profile and courier profile"
        param :email, String, required: true
        param :password, String, required: true
        example %q{{
  "data": {
    "type":"user",
    "id":1,
    "provider":"email",
    "uid":"user-1@noggalito.com",
    "name":null,
    "nickname":null,
    "image":null,
    "email":"user-1@noggalito.com",
    "info":null,
    "credentials":null,
    "provider_profile":{
      "id":1,
      "ruc":"5563195142",
      "razon_social":"Cadena Hermanos",
      "nombre_establecimiento":"Gaitán y Pineda",
      "actividad_economica":"designer",
      "representante_legal":"Víctor Armijo Atencio",
      "telefono":"915.647.955",
      "email":"patience@schinner.io",
      "website":"http://schmelerwyman.com/ania",
      "formas_de_pago":["efectivo"],
      "logotipo":null,
      "facebook_handle":"enos",
      "twitter_handle":"bennett_nitzsche",
      "instagram_handle":"madisen.rowe",
      "youtube_handle":"adam_legros",
      "banco_nombre":"Cantabria vampires",
      "banco_numero_cuenta":"93-9332946",
      "banco_tipo_cuenta":"Ahorros"
      "offices":[{
        "id":1,
        "direccion":"Partida Yolanda, 39",
        "ciudad":"Rubí",
        "horario":"10:00 AM - 7:00 PM",
        "enabled":false
      }]
    }
  }
}}
      end

      doc_for :sign_out do
        api :DELETE,
            "/auth/user/sign_out",
            "log out"
        description "aka end session"
      end

      protected

      def render_create_success
        render "api/auth/sessions/user"
      end
    end
  end
end
