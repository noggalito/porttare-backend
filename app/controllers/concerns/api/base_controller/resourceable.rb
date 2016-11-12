module Api
  class BaseController < ::ApplicationController
    module Resourceable
      def create
        @api_resource = resource_scope.new(resource_params)
        if @api_resource.save
          render resource_identifier, status: :created
        else
          render "api/shared/resource_error",
                 status: :unprocessable_entity
        end
      end

      protected

      def resource_scope
        policy_scope(resource_klass)
      end

      def resource_params
        params.permit(
          *policy(resource_klass).permitted_attributes
        )
      end

      def resource_identifier
        resource_klass.to_s.underscore.to_sym
      end

      def pundit_authorize
        authorize(resource_klass)
      end

      private

      def resource_klass
        raise NotImplementedError
      end
    end
  end
end
