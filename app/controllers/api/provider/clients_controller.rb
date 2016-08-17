module Api
  module Provider
    class ClientsController < BaseController
      resource_description do
        name "Provider::ClientsController"
        short "provider clients endpoint"
      end

      before_action :authenticate_api_auth_user!

      api :POST,
          "/provider/clients",
          "Create a provider client"
      param :notas, String
      param :ruc, String, required: true
      param :nombres, String, required: true
      param :direccion, String, required: true
      param :telefono, String, required: true
      param :email, String, required: true
      def create
        authorize ProviderClient
        @provider_client =
          current_api_auth_user
            .provider_profile
            .provider_clients.new(provider_client_params)
        if @provider_client.save
          render nothing: true, status: :created
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
    end
  end
end
