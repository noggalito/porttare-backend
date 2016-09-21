# == Schema Information
#
# Table name: courier_profiles
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  nombres                 :string
#  ruc                     :string
#  telefono                :string
#  email                   :string
#  ubicacion               :integer
#  tipo_medio_movilizacion :integer
#  fecha_nacimiento        :date
#  tipo_licencia           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe CourierProfile,
               type: :model do
  describe "factory" do
    subject { build :courier_profile }
    it { is_expected.to be_valid }
  end
end
