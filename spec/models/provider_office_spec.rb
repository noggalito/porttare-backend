# == Schema Information
#
# Table name: provider_offices
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  enabled             :boolean          default(FALSE)
#  direccion           :string           not null
#  ciudad              :string
#  horario             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  telefono            :string
#

require 'rails_helper'

RSpec.describe ProviderOffice,
               type: :model do
  describe "factory" do
    subject { build :provider_office }
    it { is_expected.to be_valid }
  end
end
