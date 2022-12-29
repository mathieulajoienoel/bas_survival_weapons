# Ruby 3.0.2
# ruby enemy_types.rb
# @author mathieulajoienoel

require_relative 'lib/option_parser'
require_relative 'lib/creature_tables'

# If the user has selected to delete the tables
enemy_types = CreatureTables.new
if OPTIONS[:delete]
  enemy_types.destroy
else
  enemy_types.create
end
