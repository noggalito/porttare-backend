module Api
  class CategoriesController < BaseController
    before_action :authenticate_api_auth_user!

    respond_to :json

    api :GET,
        "/categories",
        "List provider categories including their providers"
    example %q{{
  "categories":[
    {
      "id":2,
      "titulo":"Alimentos preparados",
      "imagen":"https://robohash.org/veniameanostrum.png?size=400x600\u0026set=set1",
      "descripcion":"Carry mustache twee brooklyn.",
      "providers":[
        {
          "id":2,
          "razon_social":"Perea S.L."
        }
      ]
    }
  ]
}}
    def index
      @categories = public_scope.order(:titulo)
                                .includes(:provider_profiles)
    end

    private

    def public_scope
      policy_scope(ProviderCategory)
    end
  end
end
