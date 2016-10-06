module Api
  module Customer
    class AddressesController < BaseController
      resource_description do
        name "Customer::Addresses"
        short "customer's address"
      end

      before_action :authenticate_api_auth_user!
      before_action :find_customer_addresses, only: [:show, :update]

      api :POST,
          "/customer/addresses",
          "Create customer's address"
          param :ciudad, String
          param :parroquia, String
          param :barrio, String
          param :direccion_uno, String
          param :direccion_dos, String
          param :codigo_postal, String
          param :referencia, String
          param :numero_convencional, String

      def create
        if create_address?
          render "api/customer/addresses/customer_address",
                 status: :created
        else
          @errors = @customer_address.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :GET,
          "/customer/addresses/:id",
          "Customer's address"
      example %q{{
  "customer_address":{
    "id":1,
    "customer_profile_id":1,
    "ciudad":"Quito",
    "parroquia":"Quito",
    "barrio":"Cumbayá",
    "direccion_uno":"Calle Miguel Ángel",
    "direccion_dos":"Lorem Impusm",
    "codigo_postal":"124455",
    "referencia":"La Primavera",
    "numero_convencional":"2342-5678"
  }
}}
    param :id, Integer, required: true

      def show
        render :customer_address
      end

      api :PUT,
          "/customer/addresses/:id",
          "Edit customer's address"
      param :id, Integer, required: true

      def update
        if @customer_address.update(customer_address_params)
          render :customer_address, status: :accepted
        else
          @errors = @customer_address.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def create_address?
        @customer_address = CustomerAddress.new(customer_address_params)
        @customer_address.customer_profile = current_api_auth_user.customer_profile
        @customer_address.save
      end

      def find_customer_addresses
        @customer_address = CustomerAddress.find(params[:id])
      end

      def customer_address_params
        params.permit(
          *policy(CustomerAddress).permitted_attributes
        )
      end
    end
  end
end
