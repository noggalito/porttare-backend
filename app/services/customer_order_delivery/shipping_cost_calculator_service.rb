class CustomerOrderDelivery < ActiveRecord::Base
  class ShippingCostCalculatorService
    def self.for_customer_order_delivery(customer_order_delivery)
      place = customer_order_delivery.customer_order.place
      origin = customer_order_delivery.provider_profile.offices.first
      target = customer_order_delivery.customer_address
      new(
        place: place,
        origin: origin,
        target: target
      )
    end

    attr_reader :place, :origin, :target

    def initialize(options)
      @place = options.fetch(:place)
      @origin = options.fetch(:origin)
      @target = options.fetch(:target)
    end

    def shipping_fare_price_cents
      shipping_fare.price_cents
    end

    private

    def shipping_fare
      ShippingFareMatcher.new(
        place: @place,
        price_cents: price_per_distance.total_price_cents_per_distance
      ).shipping_fare
    end

    def price_per_distance
      PricePerDistanceCalculator.new(self)
    end
  end
end
