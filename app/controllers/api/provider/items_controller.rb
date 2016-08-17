module Api
  module Provider
    class ItemsController < BaseController
      resource_description do
        name "Provider::ItemsController"
        short "provider items endpoint"
      end

      before_action :authenticate_api_auth_user!

      api :GET,
          "/provider/items",
          "Lists a provider's items"
      desc "item's price is described in cents"
      example %q{{
  "provider_items":[
    {
      "id":1,
      "titulo":"Rustic Silk Pants",
      "descripcion":"data-warehouse 4th generación Orígenes",
      "unidad_medida":"volumen",
      "precio_cents":4079,
      "volumen":"798",
      "peso":"986 kg",
      "imagen":"https://robohash.org/aliquamdelenitiquisquam.png?size=50x50\u0026set=set1",
      "observaciones":"Marfa 90's xoxo shoreditch. Selvage butcher trust fund. Pickled polaroid echo hammock.\nKickstarter stumptown gastropub. Ramps chambray letterpress. Etsy ramps sustainable selfies tousled.\nPhoto booth loko chambray art party chillwave umami street tilde. Truffaut hammock knausgaard. Cronut messenger bag banh mi bushwick.",
      "created_at":"2016-08-17T17:21:04.569-05:00",
      "updated_at":"2016-08-17T17:21:04.569-05:00"
    }
  ]
}}
      def index
        @provider_items = policy_scope(ProviderItem)
      end

      api :POST,
          "/provider/items",
          "Create a provider item"
      param :titulo, String, required: true
      param :descripcion, String
      param :precio, Float, required: true
      param :volumen, String
      param :peso, String
      param :imagen, File
      param :observaciones, String
      param :unidad_medida,
            String,
            "one of the following: #{ProviderItem::UNIDADES_MEDIDA.join(", ")}"
      def create
        authorize ProviderItem
        if create_item?
          render nothing: true, status: :created
        else
          @errors = @provider_item.errors
          render "api/shared/create_error",
                 status: :unprocessable_entity
        end
      end

      private

      def create_item?
        @provider_item =
          current_api_auth_user
            .provider_profile
            .provider_items.new(provider_item_params)
        @provider_item.save
      end

      def provider_item_params
        params.permit(
          *policy(ProviderItem).permitted_attributes
        )
      end
    end
  end
end
