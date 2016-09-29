module Api
  module Provider
    class DispatchersController < BaseController
      resource_description do
        name "Provider::Dispathchers"
        short "provider's dispatchers"
      end

      before_action :authenticate_api_auth_user!
      before_action :find_provider_dispatcher,
                    only: [:update, :destroy]

      api :GET,
          "/provider/dispatchers",
          "Lists provider's dispatchers"
      example %q{{
        "provider_dispatchers":[
          {
            "id":1,
            "email":"karelle@luettgenlueilwitz.name",
            "ruc":"961770900-7",
            "nombres":"Perico de los Palotes",
            "email":"karelle@luettgenlueilwitz.name",
            "local": {
              nombre: "sucursal 666",
              id: 1
            }
          }
        ]
      }}
      def index
        authorize ProviderDispatcher
        @provider_dispatchers = provider_scope
      end

      def_param_group :provider_dispatcher do
        param :email, String, required: true
        param :ruc, String, required: true
        param :provider_office_id, Integer, required: true
      end

      api :POST,
          "/provider/dispatchers",
          "Create a provider dispatcher"
      param_group :provider_dispatcher
      def create
        authorize ProviderDispatcher
        user = User.find_by_email provider_client_params.email
        @provider_dispatcher =
          current_api_auth_user
            .provider_profile
            .provider_dispatchers.new(provider_dispatcher_params)
        @provider_dispatcher.user = user if user
        if @provider_dispatcher.save
          render :dispatcher, status: :created
        else
          @errors = @provider_dispatcher.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :PUT,
          "/provider/dispatchers/:id",
          "Update a provider's dispatcher"
      param :id,
            Integer,
            required: true,
            desc: "Provider dispatcher's id"
      param_group :provider_dispatcher
      def update
        authorize @provider_dispatcher
        if @provider_dispatcher.update_attributes(provider_client_params)
          render :client, status: :accepted
        else
          @errors = @provider_client.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      api :DELETE,
          "/provider/dispatchers/:id",
          "Delete a provider's dispatcher"
      desc "a soft delete is performed"
      param :id,
            Integer,
            required: true,
            desc: "Provider dispatcher's id"
      def destroy
        authorize @provider_dispatcher
        @provider_dispatcher.soft_destroy
        head :no_content
      end

      private

      def provider_client_params
        params.permit(
          *policy(ProviderDispatcher).permitted_attributes
        )
      end

      def find_provider_dispatcher
        @provider_dispatcher = provider_scope.find(params[:id])
      end

      def provider_scope
        policy_scope(ProviderDispatcher)
      end
    end
  end
end
