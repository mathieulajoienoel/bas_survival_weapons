# Ruby 3.3.4
# ruby main.rb
# @author mathieulajoienoel
require 'fileutils'
require_relative 'lib/option_parser'

require_relative 'lib/mod_parser'
require_relative 'lib/loot_tables'
require_relative 'lib/waves'

class Main

  def create
    # Prepare the waves
    waves = Waves.new.execute
    # Prepare the loot_tables
    loot_tables = LootTables.new.execute

    # Copy template mod to mod folder
    FileUtils.mkdir_p("./../mln_better_survival")
    FileUtils.copy_entry('./templates/', "./../mln_better_survival/", true)
  end

  def delete
    Dir.delete("./../mln_better_survival")
  end

end

mod = Main.new
if OPTIONS[:delete]
  mod.delete
else
  mod.create
end
