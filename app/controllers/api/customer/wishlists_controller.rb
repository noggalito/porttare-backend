module Api
  module Customer
    class WishlistsController < BaseController
      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile,
                    except: :index
      before_action :find_customer_wishlist,
                    only: [:update, :destroy]
      before_action :pundit_authorize,
                    only: [:index, :create]

      resource_description do
        name "Customer::Wishlists"
        short "current customer's wishlists"
      end

      api :GET,
          "/customer/wishlists",
          "customer wishlists. response sideloads public provider profiles and provider items"
      example %q{{
  "customer_wishlists":[
    {
      "id":4,
      "nombre":"90's meditation farm-to-table.",
      "provider_items":[
        {
          "provider_profile_id":2,
          "id":2,
          "titulo":"Intelligent Marble Shirt",
          "descripcion":"contingencia 4th generación Progresivo",
          "unidad_medida":"peso",
          "precio_cents":1889,
          "volumen":"428",
          "peso":"693 kg",
          "observaciones":"Next level narwhal gluten-free heirloom. Master small batch drinking ethical kogi cred helvetica. Fap lomo polaroid. Keffiyeh poutine heirloom bespoke.\nYou probably haven't heard of them gentrify retro fap. Chambray street chartreuse meditation cornhole brunch slow-carb keffiyeh. Cold-pressed keffiyeh try-hard. Twee retro lumbersexual loko poutine food truck sartorial freegan.",
          "imagenes":[]
        }
      ]
    }
  ],
  "provider_profiles":[
    {
      "provider_category_id":2,
      "id":2,
      "ruc":"0642772833",
      "razon_social":"Maldonado, Nieto y Barrera Asociados",
      "nombre_establecimiento":"Carrion Hermanos",
      "actividad_economica":"agriculturist",
      "representante_legal":"Rafael Sáenz Osorio",
      "telefono":"996.620.499",
      "email":"axel@halvorson.com",
      "website":"http://lynch.org/vaughn.hilll",
      "formas_de_pago":["tarjeta_credito"],
      "logotipo_url":null,
      "facebook_handle":"pink.williamson",
      "twitter_handle":"diana",
      "instagram_handle":"leanna_mclaughlin",
      "youtube_handle":"rosamond.miller"
    }
  ]
}
      }
      def index
        if current_api_auth_user.customer_profile
          @customer_wishlists = customer_scope
          @provider_profiles = get_provider_profiles(
            @customer_wishlists.map(&:provider_items).flatten
          )
        else
          skip_policy_scope
        end
      end

      def_param_group :customer_wishlist do
        param :nombre,
              String,
              required: true,
              desc: "Nombre para identificar la lista"
        param :entregar_en,
              Time,
              "Permite especificar al cliente la fecha y hora de entrega deseada"
        param :provider_items_ids,
              Array,
              "Arreglo con los ítems que pertenecen a la lista"
      end

      api :POST,
          "/customer/wishlists",
          "create a wishlist"
      param_group :customer_wishlist
      def create
        @customer_wishlist = customer_scope.new(customer_wishlist_params)
        if @customer_wishlist.save
          @provider_profiles = get_provider_profiles(@customer_wishlist.provider_items)
          render :customer_wishlist, status: :created
        else
          @errors = @customer_wishlist.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :PUT,
          "/customer/wishlists/:id",
          "update a wishlist"
      param :id,
            Integer,
            required: true,
            desc: "customer wishlist's id"
      param_group :customer_wishlist
      def update
        authorize @customer_wishlist
        if @customer_wishlist.update(customer_wishlist_params)
          @provider_profiles = get_provider_profiles(@customer_wishlist.provider_items)
          render :customer_wishlist, status: :created
        else
          @errors = @customer_wishlist.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :DELETE,
          "/customer/wishlists/:id",
          "destroy a wishlist"
      param :id,
            Integer,
            required: true,
            desc: "wishlist's id"
      def destroy
        authorize @customer_wishlist
        @customer_wishlist.destroy
        head :no_content
      end

      private

      def pundit_authorize
        authorize CustomerWishlist
      end

      def find_customer_wishlist
        @customer_wishlist = customer_scope.find(params[:id])
      end

      def customer_scope
        policy_scope(CustomerWishlist)
      end

      def customer_wishlist_params
        params.permit(
          *policy(CustomerWishlist).permitted_attributes
        )
      end

      def get_provider_profiles(provider_items)
        # is this too much for the controller?
        # could probably be avoided by adding a
        # proper relationship
        provider_profile_ids = provider_items.map(&:provider_profile_id)
        ProviderProfile.where(
          id: provider_profile_ids
        )
      end
    end
  end
end
