# == Schema Information
#
# Table name: shipping_requests
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  resource_type       :string           not null
#  kind                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string           default("new"), not null
#  address_attributes  :json
#  courier_profile_id  :integer
#  reason              :string
#  place_id            :integer          not null
#  waypoints           :json
#  estimated_time_mins :integer
#  assigned_at         :datetime
#  ref_lat             :float            not null
#  ref_lon             :float            not null
#

class ShippingRequest < ActiveRecord::Base
  extend Enumerize

  STATUSES = [
    :new,
    :assigned,
    :in_progress, # or phase1 & phase2
    :delivered,
    :canceled
  ].freeze
  KINDS = [
    :ask_to_validate,
    :customer_order_delivery
  ].freeze

  has_paper_trail

  acts_as_mappable(
    lat_column_name: :ref_lat,
    lng_column_name: :ref_lon
  )

  begin :callbacks
    before_validation :set_ref_coordinates
  end

  begin :relationships
    belongs_to :place
    belongs_to :courier_profile
    belongs_to :resource, polymorphic: true
  end

  begin :enumerables
    enumerize :kind,
              in: KINDS,
              scope: true,
              i18n_scope: "shipping_request.kinds"
    enumerize :status,
              in: STATUSES,
              scope: true,
              i18n_scope: "shipping_request.statuses"
  end

  begin :validations
    ##
    # resource may be the provider we need to validate
    # resource may be what we're delivering (customer_order_delivery)
    validates :resource,
              :kind,
              :status,
              :place_id,
              :ref_lat,
              :ref_lon,
              presence: true
  end

  begin :scopes
    scope :latest, ->{
      order(created_at: :desc)
    }
    scope :for_place, ->(place){
      where(place_id: place.id)
    }
  end

  def estimated_delivery_at
    if assigned_at.present? && estimated_time_mins.present?
      # TODO
      # consider provider's preparation time
      assigned_at + estimated_time_mins.minutes
    end
  end

  private

  def set_ref_coordinates
    self.ref_lat = address_attributes["lat"]
    self.ref_lon = address_attributes["lon"]
  end
end
