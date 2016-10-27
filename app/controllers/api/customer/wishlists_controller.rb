module Api
  module Customer
    class WishlistsController < BaseController
      before_action :authenticate_api_auth_user!
      before_action :find_or_create_customer_profile,
                    except: :index
      before_action :find_customer_wishlist,
                    only: [:update, :destroy]

      resource_description do
        name "Customer::Wishlists"
        short "current customer's wishlists"
      end

      api :GET,
          "/customer/wishlists",
          "customer wishlists"
      example %q{{
  "customer_wishlists":[
    {
      "id":3,
      "nombre":"Twee raw denim.",
      "provider_items_ids":[1,2],
      "entregar_en":"2016-11-06 20:02 -0500"
    }
  ]
}
      }
      def index
        authorize CustomerWishlist
        if current_api_auth_user.customer_profile
          @customer_wishlists = customer_scope
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
        @customer_wishlist =
          @customer_profile
            .customer_wishlists.new(customer_wishlist_params)
        if @customer_wishlist.save
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
    end
  end
end
