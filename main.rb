# Ruby 3.0.2
# ruby enemy_types.rb
# @author mathieulajoienoel

require_relative 'lib/option_parser'
require_relative 'lib/creature_tables'
require_relative 'lib/enemy_weapons'
require_relative 'lib/survival_weapons'

# If the user has selected to delete the tables
enemy_types = CreatureTables.new
enemy_weapons = EnemyWeapons.new
survival_weapons = SurvivalWeapons.new
if OPTIONS[:delete]
  puts "Removing enemy_types" if !OPTIONS[:quiet]
  enemy_types.destroy
  puts "Removing enemy_weapons" if !OPTIONS[:quiet]
  enemy_weapons.destroy
  puts "Removing survival_weapons" if !OPTIONS[:quiet]
  survival_weapons.destroy
else
  puts "Adding enemy_types" if !OPTIONS[:quiet]
  enemy_types.create
  puts "Adding enemy_weapons" if !OPTIONS[:quiet]
  enemy_weapons.create
  puts "Adding survival_weapons" if !OPTIONS[:quiet]
  survival_weapons.create
end
