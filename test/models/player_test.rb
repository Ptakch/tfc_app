# == Schema Information
#
# Table name: players
#
#  id            :integer          not null, primary key
#  name          :text
#  steam_id      :text
#  red_kills     :integer          default(0)
#  red_deaths    :integer          default(0)
#  red_tks       :integer          default(0)
#  red_fck       :integer          default(0)
#  red_maps      :integer          default(0)
#  blue_kills    :integer          default(0)
#  blue_deaths   :integer          default(0)
#  blue_tks      :integer          default(0)
#  blue_touches  :integer          default(0)
#  blue_initials :integer          default(0)
#  blue_sgs      :integer          default(0)
#  blue_caps     :integer          default(0)
#  blue_maps     :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  team_id       :integer
#

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
