module Api
  class ProvidersController < BaseController
    before_action :authenticate_api_auth_user!
    before_action :find_category,
                  only: [:index, :show]
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
    end

    api :GET,
        "/categories/:category_id/providers/:id",
        "Provider information"
    desc "includes full products info"
    example %q{{
  "provider":{
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
    "products":[
      {
        "id":1,
        "titulo":"Rustic Silk Pants",
        "descripcion":"data-warehouse 4th generación Orígenes",
        "unidad_medida":"volumen",
        "precio_cents":4079,
        "volumen":"798",
        "peso":"986 kg",
        "observaciones":"Marfa 90's xoxo shoreditch. Selvage butcher trust fund. Pickled polaroid echo hammock.\nKickstarter stumptown gastropub",
        "created_at":"2016-08-17T17:21:04.569-05:00",
        "updated_at":"2016-08-17T17:21:04.569-05:00",
        "imagenes":[
          {
            "id":1,
            "imagen_url":"https://robohash.org/aliquamdelenitiquisquam.png?size=50x50\u0026set=set1"
          }
        ]
      }
    ]
  }
}}
    param :category_id, Integer, required: true
    param :id, Integer, required: true
    def show
      @provider = @category.provider_profiles.find(params[:id])
    end

    private

    def public_scope
      policy_scope(ProviderCategory)
    end

    def find_category
      @category = public_scope.find(params[:category_id])
    end
  end
end
