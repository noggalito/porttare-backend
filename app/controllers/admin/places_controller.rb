module Admin
  class PlacesController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_type = "Place"

    def index
      pundit_authorize
      @resource_collection = resource_scope.order(:country).decorate
    end
  end
end
