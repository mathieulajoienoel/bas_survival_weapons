# Get options
require 'optparse'

options = {
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
    options[:quiet] = true
  end

  opts.on('-y', '--force-yes', 'Force Yes to all prompts. Default false') do |v|
    options[:force_yes] = true
  end

  # App options
  opts.on('-d', '--delete', 'Delete tables that were added by this script. Default false') do |v|
    options[:delete] = true
  end

  # opts.on('-a', '--add', 'Add loot tables to all mods in the mods folder. Default true') do |v|
  #   options[:add] = true
  # end

  # opts.on('-x', '--add-here', 'Creates loot tables in this mod, containing all the weapons from the other mods. Default false') do |v|
  #   options[:add_here] = true
  # end

  opts.on('-p', '--print-weapon-ids', 'Print the weapon ids that were found and don\'t create any tables. Default false') do |v|
    options[:print_weapon_ids] = true
  end

  opts.on('-m', '--add-marker', 'Add the file that indicates that the loot tables are managed by this script. If the marker is not present, the tables won\'t be regenerated the next time this script is run. Default true') do |v|
    options[:add_marker] = true
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit 0
  end

end.parse!

if !options[:quiet]
  puts "Current options are :"
  options.map { |k,v| puts "#{k} : #{v}" }
end

# if !options[:origin]
#   system "ruby #{__FILE__} -h"
#   exit 1
# end
