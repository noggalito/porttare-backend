module Api
  module Provider
    class ClientsController < BaseController
      include Api::BaseController::Resourceable

      resource_description do
        name "Provider::Clients"
        short "provider's clients"
      end

      self.resource_klass = ProviderClient

      before_action :authenticate_api_auth_user!
      before_action :find_provider_client,
                    only: [:update, :destroy]
      before_action :pundit_authorize,
                    only: [:index, :create]

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
      "email":"karelle@luettgenlueilwitz.name",
      "created_at":"2016-09-24T09:15:53.617-05:00"
    }
  ]
}}
      def index
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
        super
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

      api :DELETE,
          "/provider/clients/:id",
          "Delete a provider's client"
      desc "a soft delete is performed"
      param :id,
            Integer,
            required: true,
            desc: "Provider client's id"
      def destroy
        authorize @provider_client
        @provider_client.soft_destroy
        head :no_content
      end
    end
  end
end
