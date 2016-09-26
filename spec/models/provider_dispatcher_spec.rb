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

require 'rails_helper'

RSpec.describe ProviderDispatcher, type: :model do
  describe "factory" do
    subject { build :provider_dispatcher }
    it { is_expected.to be_valid }
  end
end
