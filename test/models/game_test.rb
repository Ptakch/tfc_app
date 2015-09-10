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
#  game_title :string
#  red_team   :string
#  blue_team  :string
#

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
