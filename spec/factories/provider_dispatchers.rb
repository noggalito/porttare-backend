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

FactoryGirl.define do
  factory :provider_dispatcher do
    user
    provider_office
    email { Faker::Internet.email }
  end
end
