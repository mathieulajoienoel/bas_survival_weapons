# Ruby 3.0.2
# ruby enemy_weapons.rb
# @author mathieulajoienoel

require_relative 'lib/option_parser'
require_relative 'lib/enemy_weapons'

# If the user has selected to delete the tables
enemy_weapons = EnemyWeapons.new
if OPTIONS[:delete]
  enemy_weapons.destroy
else
  enemy_weapons.create
end
