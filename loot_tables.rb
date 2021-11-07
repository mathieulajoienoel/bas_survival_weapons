# Ruby 3.0.2
# ruby loot_tables.rb
# @author mathieulajoienoel

# Dependencies
require 'json'
require 'fileutils'
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

class App

  # Folder where all the Blade and Sorcery mods are.
  MOD_FOLDER = "./../"
  # The name ot the LootTables folder
  EXPORT_FOLDER_NAME = "LootTables"
  # The excluded weapons config file
  EXCLUDED_IDS_FILENAME = "excluded_weapons.json"
  # The excluded weapon ids
  EXCLUDED_WEAPONS_IDS = JSON.parse(File.read(EXCLUDED_IDS_FILENAME))
  EXCLUDED_WEAPONS_IDS.map!(&:downcase)
  # File marker name
  MADE_BY_ME_MARKER = "managed_by_mln"

  # require_relative 'config/vars' # Load the config
  # include Config

  # require_relative 'lib/utils' # Add the utility functions
  # include Utils
  def filter_weapon_ids(weapon_ids)
    # Filter the weapons
    weapon_ids = weapon_ids - EXCLUDED_WEAPONS_IDS
    weapon_ids.each_with_index do |wid, i|
      weapon_ids[i] = nil if EXCLUDED_WEAPONS_IDS.include?(wid.downcase)
    end
    # Make sure we only have unique entries
    return weapon_ids.compact.uniq
  end

  def get_weapon_ids(mod_path)
    # Get all weapon ids
    weapon_ids = []
    weapon_files = Dir["#{mod_path}/**/Item_Weapon_*.json"] + Dir["#{mod_path}/**/Item_Shield_*.json"] + Dir["#{mod_path}/**/Item_Arrow_*.json"]
    weapon_files.each do |fname|
      begin
        data = JSON.parse(File.read(fname))
        weapon_ids << data['id'] if !data["id"].nil?
      rescue StandardError => error
        puts "Failed to parse #{fname}"
        puts error.inspect
        next
      end
    end
    return weapon_ids
  end

  def create_tables(mod_path, weapon_ids)
    export_folder = File.join(mod_path, EXPORT_FOLDER_NAME)
    # Setup the base file contents
    FileUtils.mkdir_p(export_folder) if !File.exists?(export_folder)
    file_data = {
      "$type" => "ThunderRoad.LootTable, Assembly-CSharp",
      "id" => "",
      "saveFolder" => "Bas",
      "version" => 1,
      "drops" => []
    }
    file_name = ""
    # Create each file
    (1..10).to_a.each do |i|
      file_data["id"] = "SurvivalRewards#{i}"
      file_data["drops"] = []

      file_name = File.join(export_folder, "LootTable_SurvivalRewards#{i}.json")

      # Add all the weapons that were found
      weapon_ids.each do |wep_id|
        file_data["drops"] << {
          "reference" => 0,
          "referenceID" => wep_id,
          "probabilityWeight" => 1.0
        }
      end

      # Save it
      file = File.new(file_name, "w+")
      if file
        file.write(file_data.to_json)
        file.close
      end
    end
    # Add a marker to know that we are managing these loot tables
    FileUtils.touch(File.join(export_folder, MADE_BY_ME_MARKER)) if OPTIONS[:add_marker]
  end

  # require_relative 'lib/add_loot_tables'
  # include Creator
  def create
    # Add the loot tables in each mod folder
    # For each mod folder
    Dir.glob(File.join(MOD_FOLDER, "/*")).each do |mod_path|
      # Is it a directory ?
      if !File.directory?(mod_path)
        puts "Skipping #{mod_path}" if !OPTIONS[:quiet]
        next
      end
      # Check that we don't already have loot tables and that the marker is present
      if File.exists?(File.join(mod_path, EXPORT_FOLDER_NAME)) && !File.exists?(File.join(mod_path, EXPORT_FOLDER_NAME, MADE_BY_ME_MARKER))
        puts "Loot tables already present in #{mod_path}. Skipping" if !OPTIONS[:quiet]
        next
      end

      puts "Fetching all weapon ids" if !OPTIONS[:quiet]
      # Get all weapon ids from this mod
      weapon_ids = get_weapon_ids(mod_path)
      weapon_ids = filter_weapon_ids(weapon_ids)

      if weapon_ids.empty?
        puts "No weapon ids for #{mod_path}. Skipping" if !OPTIONS[:quiet]
        next
      end

      if OPTIONS[:print_weapon_ids]
        # Print the found weapon ids
        puts mod_path.inspect
        weapon_ids.map { |w| puts w.inspect }
        # exit 0
      else
        puts "Creating tables for #{mod_path} with #{weapon_ids.length} weapons" if !OPTIONS[:quiet]
        # Create the json data for the loot tables and save the files
        create_tables(mod_path, weapon_ids)
      end
    end

    puts 'Done' if !OPTIONS[:quiet]
    exit 0
  end

  # require_relative 'lib/delete_loot_tables'
  # include Destroyer
  def destroy
    # Get all mod folders
    to_delete = []
    loot_table_folder_path = nil
    marker_file_path = nil
    Dir.glob(File.join(MOD_FOLDER, "/*")).each do |mod_path|
      # Is it a folder ?
      next if !File.directory?(mod_path)
      # Get the LootTables folder
      loot_table_folder_path = File.join(mod_path, EXPORT_FOLDER_NAME)
      # Get the marker file path
      marker_file_path = File.join(loot_table_folder_path, MADE_BY_ME_MARKER)
      # Make sure the marker and the loot table folder are there
      next if !(File.exists?(loot_table_folder_path) && File.exists?(marker_file_path))
      # Add the folder to the array
      to_delete << loot_table_folder_path
    end

    # Give the user a chance to review the files to delete
    if !OPTIONS[:quiet]
      puts "Folders that will be deleted :"
      to_delete.map { |f| puts f.inspect }
    end
    # Get the users answer
    if !OPTIONS[:force_yes]
      puts "Do you want to delete these folders (Y/n)"
      ans = gets.chomp
    else
      ans = "Y"
    end

    # Remove the files
    if ans == "Y"
      to_delete.each do |fname|
        FileUtils.rm_rf(fname)
        puts "Removed #{fname}" if !OPTIONS[:quiet]
      end
    end

    puts 'Done' if !OPTIONS[:quiet]
    exit 0
  end

end


# If the user has selected to delete the tables
app = App.new
if OPTIONS[:delete]
  app.destroy
else
  app.create
end
