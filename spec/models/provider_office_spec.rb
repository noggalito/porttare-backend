# == Schema Information
#
# Table name: provider_offices
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  enabled             :boolean          default(FALSE)
#  direccion           :string           not null
#  ciudad              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  telefono            :string
#  hora_de_apertura    :time
#  hora_de_cierre      :time
#

require 'rails_helper'

RSpec.describe ProviderOffice,
               type: :model do
  describe "factory" do
    subject { build :provider_office }
    it { is_expected.to be_valid }
  end

  describe "allows saving a time with format HH:MM" do
    let(:provider_office) { create :provider_office }
    it {
      expect(
        provider_office.hora_de_cierre.strftime("%H:%M %p")
      ).to eq("19:00 PM")
    }
  end
end
