# == Schema Information
#
# Table name: customer_wishlists
#
#  id                  :integer          not null, primary key
#  customer_profile_id :integer          not null
#  nombre              :string           not null
#  provider_items_ids  :text             default([]), is an Array
#  entregar_en         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CustomerWishlist < ActiveRecord::Base
  # First intention was to inherit from CustomerOrder
  # but it seems we won't handle order items' qtys
  # and other stuff in here
  belongs_to :customer_profile

  validates :nombre, presence: true
end
