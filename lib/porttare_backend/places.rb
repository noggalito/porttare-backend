module PorttareBackend
  class Places
    class << self
      def all
        @@all ||= [
          "Loja",
          "Quito"
        ].freeze
      end
    end
  end
end
