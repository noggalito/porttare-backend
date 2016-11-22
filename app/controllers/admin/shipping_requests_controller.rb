module Admin
  class ShippingRequestsController < BaseController
    include Admin::BaseController::Resourceable

    self.resource_klass = ShippingRequest

    def index
    end

    def show
      super
    end

    private

    def resources_with_status(status)
      @resources_with_status ||= {}
      @resources_with_status.fetch(status) {
        @resources_with_status[status] = resource_scope.with_status(status).includes(:resource).decorate
      }
    end
    helper_method :resources_with_status
  end
end
