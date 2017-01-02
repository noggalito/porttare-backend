class CustomerOrder < ActiveRecord::Base
  module ProviderResponse
    class GenericResponseService
      protected

      def customer_order_delivery
        @customer_order_delivery ||= @customer_order.delivery_for_provider(
          @provider.provider_profile
        )
      end

      def notify_pusher!
        CustomerOrder::PusherNotifierService.delay.notify!(@customer_order)
      end
    end
  end
end
