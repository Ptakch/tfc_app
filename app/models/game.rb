# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  file_name  :string
#  game_date  :datetime
#  map        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Game < ActiveRecord::Base
end
