# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Team.destroy_all
 
t1 = Team.create :name => "[G]"
t2 = Team.create :name => "|RoK|"
t3 = Team.create :name => "[DHL]"


