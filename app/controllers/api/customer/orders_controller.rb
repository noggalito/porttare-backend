module Api
  module Customer
    class OrdersController < Customer::BaseController
      include Api::BaseController::Scopable
      include Api::Customer::BaseController::ResourceCollectionable

      resource_description do
        name "Customer::Orders"
        short "customer's previous orders"
      end
      
      self.resource_klass = CustomerOrder
      
      before_action :authenticate_api_auth_user!
      
      api :GET,
          "/customer/orders",
          "customer's previous orders"
      see "customer-cart-items#index", "Customer::Cart::Items#index for customer order serialization in response"
      def index
        super
      end
      
      private
      
      def resource_scope
        policy_scope(resource_klass).submitted
      end
    end
  end
end
