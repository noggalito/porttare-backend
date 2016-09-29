# == Schema Information
#
# Table name: provider_dispatchers
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider_office_id :integer
#  email              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProviderDispatcher < ActiveRecord::Base
  begin :relationships
    belongs_to :provider_profile
    belongs_to :provider_office
  end
end
