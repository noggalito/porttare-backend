module Api
  module Provider
    class ClientsController < BaseController
      resource_description do
        name "Provider::ClientsController"
        short "provider clients endpoint"
      end

      before_action :authenticate_api_auth_user!
      before_action :find_provider_client, only: :update

      api :GET,
          "/provider/clients",
          "Lists provider's clients"
      example %q{{
  "provider_clients":[
    {
      "id":1,
      "notas":"jerarquía analizada Diverso",
      "ruc":"961770900-7",
      "nombres":"Urías S.A.",
      "direccion":"Subida Clemente Zapata, 9 Esc. 773",
      "telefono":"972 299 498",
      "email":"karelle@luettgenlueilwitz.name"
    }
  ]
}}
      def index
        authorize ProviderClient
        @provider_clients = provider_scope
      end

      def_param_group :provider_client do
        param :notas, String
        param :ruc, String, required: true
        param :nombres, String, required: true
        param :direccion, String, required: true
        param :telefono, String, required: true
        param :email, String, required: true
      end

      api :POST,
          "/provider/clients",
          "Create a provider client"
      param_group :provider_client
      def create
        authorize ProviderClient
        @provider_client =
          current_api_auth_user
            .provider_profile
            .provider_clients.new(provider_client_params)
        if @provider_client.save
          render :client, status: :created
        else
          @errors = @provider_client.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :PUT,
          "/provider/clients/:id",
          "Update a provider's client"
      param :id,
            Integer,
            required: true,
            desc: "Provider client's id"
      param_group :provider_client
      def update
        authorize @provider_client
        if @provider_client.update_attributes(provider_client_params)
          render :client, status: :accepted
        else
          @errors = @provider_client.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def provider_client_params
        params.permit(
          *policy(ProviderClient).permitted_attributes
        )
      end

      def find_provider_client
        @provider_client = provider_scope.find(params[:id])
      end

      def provider_scope
        policy_scope(ProviderClient)
      end
    end
  end
end
