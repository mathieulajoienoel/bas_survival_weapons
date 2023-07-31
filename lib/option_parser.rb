require 'optparse'

# Load the command line options
# require_relative 'lib/option_parser' # Gives the options object
# include Options
OPTIONS = {
  quiet: false,
  force_yes: false,
  delete: false,
  print_item_ids: false,
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

  opts.on('-p', '--print-weapon-ids', 'Print the weapon ids that were found and don\'t create any tables. Default false') do |v|
    OPTIONS[:print_item_ids] = true
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
