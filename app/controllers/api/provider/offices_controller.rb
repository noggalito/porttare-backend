module Api
  module Provider
    class OfficesController < Provider::BaseController
      include Api::BaseController::Resourceable
      include Api::Provider::BaseController::ResourceCollectionable

      resource_description do
        name "Provider::Offices"
        short "provider offices (branches)"
      end

      self.resource_klass = ProviderOffice

      before_action :authenticate_api_auth_user!
      before_action :pundit_authorize, only: :show
      before_action :find_api_resource, only: :show

      api :GET,
          "/provider/offices",
          "List provider's offices (branches). Response includes full provider office attributes"
      example %q{
{
  "provider_offices":[
    {
      "id":1,
      "direccion":"Subida Martín Guardado 5",
      "ciudad":"Loja",
      "telefono":"945260520",
      "hora_de_apertura":"15:00 +0000",
      "hora_de_cierre":"00:00 +0000",
      "enabled":false,
      "final_de_labores":"sun",
      "inicio_de_labores":"fri"
    }
  ]
}
      }
      def index
        super
      end

      def_param_group :provider_office do
        param :ciudad,
              PorttareBackend::Places.all,
              required: true
        param :telefono,
              String,
              required: true,
              desc: "un teléfono por sucursal"
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
        param :final_de_labores,
              ProviderOffice.final_de_labores.values
        param :inicio_de_labores,
              ProviderOffice.final_de_labores.values
      end

      api :POST,
          "/provider/offices",
          "create a provider office"
      param_group :provider_office
      def create
        super
      end

      api :PUT,
          "/provider/offices/:id",
          "update a provider's office"
      param :id, Integer, required: true, desc: "provider office id"
      param_group :provider_office
      def update
        super
      end

      api :GET,
          "/provider/offices/:id",
          "A provider office (branches). Response includes full provider office attributes"
      example %q{
{
  "provider_office":{
    "id":1,
    "direccion":"Subida Martín Guardado 5",
    "ciudad":"Loja",
    "telefono":"945260520",
    "hora_de_apertura":"15:00 +0000",
    "hora_de_cierre":"00:00 +0000",
    "enabled":false,
    "final_de_labores":"sun",
    "inicio_de_labores":"fri"
  }
}
      }
      param :id, Integer, required: true, desc: "provider office id"
      def show
        super
      end

      private

      def find_provider_office
        @provider_office = provider_scope.find(params[:id])
      end
    end
  end
end
