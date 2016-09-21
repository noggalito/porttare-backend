module Api
  class ProvidersController < BaseController
    before_action :authenticate_api_auth_user!

    respond_to :json

    resource_description do
      short "providers from a category"
    end

    api :GET,
        "/categories/:category_id/providers",
        "List of providers that belong to a category"
    desc "includes full provider info"
    example %q{{
  "category":{
    "id":2,
    "titulo":"Alimentos preparados",
    "imagen":"https://robohash.org/veniameanostrum.png?size=400x600\u0026set=set1",
    "descripcion":"Carry mustache twee brooklyn.",
    "providers":[
      {
        "id":2,
        "nombre_establecimiento":"Perea S.L.",
        "telefono":"946 381 185",
        "email":"titus.wiegand@walker.org",
        "offices":[
          {
            "id":2,
            "direccion":"Barrio Emilia 9",
            "ciudad":"Gecho",
            "horario":"10:00 AM - 7:00 PM",
            "enabled":false
          }
        ]
      }
    ]
  }
}}
    param :category_id, Integer, required: true
    def index
      @category = public_scope.find(params[:category_id])
    end

    private

    def public_scope
      policy_scope(ProviderCategory)
    end
  end
end
