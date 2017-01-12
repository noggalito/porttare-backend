# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  lat        :string
#  lon        :string
#  nombre     :string           not null
#  country    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ActiveRecord::Base
  has_paper_trail

  validates :nombre,
            :country,
            presence: true
end
