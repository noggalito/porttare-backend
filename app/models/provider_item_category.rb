# == Schema Information
#
# Table name: provider_item_categories
#
#  id                  :integer          not null, primary key
#  nombre              :string
#  predeterminada      :boolean          default(FALSE)
#  provider_profile_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProviderItemCategory < ActiveRecord::Base
  belongs_to :provider_profile
  has_many :provider_items

  def self.default
    where(predeterminada: true).first
  end
end
