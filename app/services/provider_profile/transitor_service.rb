class ProviderProfile < ActiveRecord::Base
  class TransitorService
    delegate :flashes, to: :@transitor

    def initialize(resource, predicate)
      @predicate = predicate
      @transitor = transitor_class.new(resource)
    end

    ##
    # @return self
    def perform!
      @transitor.perform
      self
    end

    private

    def transitor_class
      (
        "ProviderProfile::TransitionTo::" +
        @predicate.classify +
        "Service"
      ).constantize
    end
  end
end
