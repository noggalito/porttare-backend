# == Schema Information
#
# Table name: provider_dispatchers
#
#  id                 :integer          not null, primary key
#  provider_office_id :integer          not null
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProviderDispatcher < ActiveRecord::Base
  validates :email, presence: true

  begin :relationships
    belongs_to :provider_office
  end
end
