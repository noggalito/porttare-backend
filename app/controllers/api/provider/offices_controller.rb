module Api
  module Provider
    class OfficesController < BaseController
      resource_description do
        name "Provider::Offices"
        short "provider offices (branches)"
      end

      before_action :authenticate_api_auth_user!
      before_action :pundit_authorize,
                    only: [:create]

      def_param_group :provider_office do
        param :direccion,
              String,
              required: true,
              desc: "Branches without `direccion` will be ignored"
        param :hora_de_apertura,
              Time,
              required: true,
              desc: "format: `%H:%M %z`. Example: `13:00 -0500`"
        param :hora_de_cierre,
              Time,
              required: true,
              desc: "format: `%H:%M %z`. Example: `13:00 -0500`"
        param :telefono,
              String,
              required: true,
              desc: "un teléfono por sucursal"
        param :ciudad,
              PorttareBackend::Places.all,
              required: true
      end

      api :POST,
          "/provider/offices",
          "create a provider office"
      param_group :provider_office
      def create
        @provider_office = provider_scope.new(provider_office_params)
        if @provider_office.save
          render :provider_office, status: :created
        else
          @errors = @provider_office.errors
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      private

      def provider_office_params
        params.permit(
          *policy(ProviderOffice).permitted_attributes
        )
      end

      def provider_scope
        policy_scope(ProviderOffice)
      end

      def pundit_authorize
        authorize ProviderOffice
      end
    end
  end
end
