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
#  admin                  :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :validatable, :omniauthable, omniauth_providers: [:facebook]

  include DeviseTokenAuth::Concerns::User # after devise
  include Serializable

  has_one :provider_profile
  has_many :locations,
           -> { order(id: :desc) },
           class_name: "UserLocation"
end
