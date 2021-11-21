# Ruby 3.0.2
# ruby survival_weapons.rb
# @author mathieulajoienoel

require_relative 'lib/option_parser'
require_relative 'lib/survival_weapons'

# If the user has selected to delete the tables
survival_weapons = SurvivalWeapons.new
if OPTIONS[:delete]
  survival_weapons.destroy
else
  survival_weapons.create
end
