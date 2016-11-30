# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  info                   :json
#  credentials            :json
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  fecha_nacimiento       :date
#  ciudad                 :string
#  privileges             :text             default([]), is an Array
#  custom_image           :string
#

class User < ActiveRecord::Base
  PRIVILEGES = [
    :admin,
    :customer_service
  ].freeze

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :validatable, :omniauthable, omniauth_providers: [:facebook]

  extend Enumerize
  include DeviseTokenAuth::Concerns::User # after devise

  enumerize :privileges,
            in: PRIVILEGES,
            multiple: true

  mount_uploader :custom_image, UserCustomImageUploader

  ##
  # define a scope for each privilege
  PRIVILEGES.each do |privilege|
    scope privilege, -> {
      where.overlap(privileges: [ privilege ])
    }
  end

  has_one :provider_profile
  has_one :courier_profile
  has_one :customer_profile
  has_many :locations,
           class_name: "UserLocation"
end
