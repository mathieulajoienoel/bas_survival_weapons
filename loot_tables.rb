# Ruby 3.0.2
# ruby loot_tables.rb
# @author mathieulajoienoel

# Dependencies
require 'json'
require 'fileutils'

# Load the command line options
include 'lib/option_parser' # Gives the options object

# options[:quiet]
# options[:force_yes]
# options[:delete]
# options[:add]
# options[:add_here]
# options[:print_weapon_ids]
# options[:add_marker]

include 'config/vars' # Load the config
include 'lib/utils' # Add the utility functions

include 'lib/remove_loot_tables'
include 'lib/add_loot_tables'
