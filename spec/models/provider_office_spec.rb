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

  describe "allows setting schedule with timezone" do
    let(:provider_office) {
      create :provider_office,
              hora_de_cierre: '23:00 -0500'
    }
    it {
      expect(
        provider_office.hora_de_cierre
      ).to be_a(DateTime)

      expect(
        provider_office.hora_de_cierre.strftime("%H:%M %z")
      ).to eq("23:00 -0500")
    }
  end
end
