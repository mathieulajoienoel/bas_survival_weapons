require 'optparse'

# Load the command line options
# require_relative 'lib/option_parser' # Gives the options object
# include Options
OPTIONS = {
  quiet: false,
  force_yes: false,
  delete: false,
  # add: true,
  # add_here: false,
  print_weapon_ids: false,
  add_marker: true
}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{__FILE__} [options]"

  opts.on('-q', '--quiet', 'Don\'t print anything. Default false') do |v|
    OPTIONS[:quiet] = true
  end

  opts.on('-y', '--force-yes', 'Force Yes to all prompts. Default false') do |v|
    OPTIONS[:force_yes] = true
  end

  # App options
  opts.on('-d', '--delete', 'Delete tables that were added by this script. Default false') do |v|
    OPTIONS[:delete] = true
  end

  # opts.on('-a', '--add', 'Add loot tables to all mods in the mods folder. Default true') do |v|
  #   OPTIONS[:add] = true
  # end

  # opts.on('-x', '--add-here', 'Creates loot tables in this mod, containing all the weapons from the other mods. Default false') do |v|
  #   OPTIONS[:add_here] = true
  # end

  opts.on('-p', '--print-weapon-ids', 'Print the weapon ids that were found and don\'t create any tables. Default false') do |v|
    OPTIONS[:print_weapon_ids] = true
  end

  opts.on('-m', '--add-marker', 'Add the file that indicates that the loot tables are managed by this script. If the marker is not present, the tables won\'t be regenerated the next time this script is run. Default true') do |v|
    OPTIONS[:add_marker] = true
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit 0
  end
end.parse!

if !OPTIONS[:quiet]
  puts "Current options are :"
  OPTIONS.map { |k,v| puts "#{k} : #{v}" }
end
