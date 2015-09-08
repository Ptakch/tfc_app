# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string           default("Unassigned")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ActiveRecord::Base

has_many :players

end
