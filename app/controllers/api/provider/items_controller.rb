module Api
  module Provider
    class ItemsController < BaseController
      resource_description do
        name "Provider::ItemsController"
        short "provider items endpoint"
      end

      before_action :authenticate_api_auth_user!
      before_action :find_provider_item, only: :update

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

      def_param_group :provider_items do
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
      end

      api :POST,
          "/provider/items",
          "Create a provider item"
      param_group :provider_items
      def create
        @provider_item =
          current_api_auth_user
            .provider_profile
            .provider_items.new(provider_item_params)
        authorize @provider_item
        if @provider_item.save
          render nothing: true, status: :created
        else
          @errors = @provider_item.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :PUT,
          "/provider/items/:id",
          "Update a provider's item"
      param :id,
            Integer,
            required: true,
            desc: "Provider item's id"
      param_group :provider_items
      def update
        authorize @provider_item
        if @provider_item.update_attributes provider_item_params
          render nothing: true, status: :accepted
        else
          @errors = @provider_item.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def find_provider_item
        @provider_item = policy_scope(
          ProviderItem
        ).find(params[:id])
      end

      def provider_item_params
        params.permit(
          *policy(ProviderItem).permitted_attributes
        )
      end
    end
  end
end
