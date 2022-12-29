require 'json'
require 'fileutils'
require_relative 'includes/weapon_parser'

class LootTables

  # Folder where all the Blade and Sorcery mods are.
  MOD_FOLDER = "./../"
  # File marker name
  MADE_BY_ME_MARKER = "managed_by_mln"

  # The excluded mods config file
  EXCLUDED_MODS_FILENAME = "excluded_mods.json"
  # The excluded mods
  EXCLUDED_MODS = JSON.parse(File.read(EXCLUDED_MODS_FILENAME))
  EXCLUDED_MODS.map! { |x| "#{MOD_FOLDER}#{x}"  }

  include WeaponParser

  def initialize
    @weapon_categories = []
  end

  def create
    # Add the loot tables in each mod folder
    # For each mod folder
    (self.mod_folders - EXCLUDED_MODS).each do |mod_path|
      # Is it a directory ?
      if !File.directory?(mod_path)
        puts "Skipping #{mod_path}" if !OPTIONS[:quiet]
        next
      end
      ex_folder = export_folder(mod_path, use_sub_folder: false)
      # Check that we don't already have loot tables and that the marker is present
      if File.exists?(ex_folder) && !File.exists?(File.join(ex_folder, MADE_BY_ME_MARKER))
        puts "#{export_folder_name} already present in #{mod_path}. Skipping" if !OPTIONS[:quiet]
        next
      end

      puts "Fetching all weapon ids for #{mod_path}" if !OPTIONS[:quiet]
      # Get all weapon ids from this mod
      weapon_ids = get_weapon_ids(mod_path, use_categories: self.use_categories)
      weapon_ids = filter_weapon_ids(weapon_ids)

      if weapon_ids.empty?
        puts "No weapon ids for #{mod_path}. Skipping" if !OPTIONS[:quiet]
        next
      end

      if OPTIONS[:print_weapon_ids]
        # Print the found weapon ids
        puts mod_path.inspect
        weapon_ids.map { |w| puts w.inspect } if !weapon_ids.empty?
        @weapon_categories.map { |w| puts w.inspect } if !@weapon_categories.empty?
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

  def destroy
    # Get all mod folders
    to_delete = []
    loot_tables_folder_path = nil
    marker_file_path = nil
    self.mod_folders.each do |mod_path|
      # Is it a folder ?
      next if !File.directory?(mod_path)
      # Get the LootTables folder
      ex_folder = export_folder(mod_path)
      loot_tables_folder_path = export_folder(mod_path) # File.join(mod_path, export_folder_name)
      # Get the marker file path
      marker_file_path = File.join(loot_tables_folder_path, MADE_BY_ME_MARKER)
      # Make sure the marker and the loot table folder are there
      next if !(File.exists?(loot_tables_folder_path) && File.exists?(marker_file_path))
      # Add the folder to the array
      to_delete << loot_tables_folder_path

      # ([ex_folder] - Dir.glob(File.join(export_folder(mod_path, use_sub_folder: false), "/*"))).inspect
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

  private

    def use_categories
      return false
    end

    def base_file_data
      return {
        "$type" => "ThunderRoad.LootTable, Assembly-CSharp",
        "id" => "",
        "saveFolder" => "Bas",
        "version" => 1,
        "drops" => []
      }
    end

    def mod_folders
      return Dir.glob(File.join(MOD_FOLDER, "/*"))
    end

    # Create all tables
    def create_tables(mod_path, weapon_ids)
      ex_folder = self.export_folder(mod_path)
      # Setup the base file contents
      create_export_folder(ex_folder)
      file_data = self.base_file_data
      file_name = ""
      # Create each file
      self.table_identifiers.each do |id|
        self.create_table(file_data, ex_folder, id, weapon_ids, file_name)
      end
      # Add a marker to know that we are managing these files
      FileUtils.touch(File.join(ex_folder, MADE_BY_ME_MARKER)) if OPTIONS[:add_marker]
    end

    # Fill the data for a table
    def create_table(file_data, ex_folder, id, weapon_ids, file_name)
      file_data["id"] = self.export_file_id(id)
      file_data["drops"] = []

      file_name = export_file_name(ex_folder, file_data["id"])

      # Add all the weapons that were found
      weapon_ids.each do |wep_id|
        file_data["drops"] << {
          "reference" => 0,
          "referenceID" => wep_id,
          "probabilityWeight" => self.probability_weight
        }
      end

      # Save it
      save_file(file_name, file_data)
    end

    def save_file(file_name, file_data)
      file = File.new(file_name, "w+")
      if file
        file.write(file_data.to_json)
        file.close
      end
    end

    def create_export_folder(ex_folder)
      FileUtils.mkdir_p(ex_folder) if !File.exists?(ex_folder)
    end

    def probability_weight
      return 1.0
    end

    def export_file_id(id = nil)
      return "#{self.base_name}#{id}"
    end

    def export_file_prefix
      return 'LootTable'
    end

    def export_file_name(ex_folder, file_id)
      return File.join(ex_folder, "#{self.export_file_prefix}_#{file_id}.json")
    end

    # The full export folder name
    def export_folder(mod_path, use_sub_folder: true)
      return File.join(mod_path, export_folder_name, self.export_sub_folder) if use_sub_folder
      return File.join(mod_path, export_folder_name)
    end

    # To override in children
    def table_identifiers
      throw Exception.new("Must be overridden")
    end

    # The file name to use
    def base_name
      throw Exception.new("Must be overridden")
    end

    # Export sub folder name
    def export_sub_folder
      throw Exception.new("Must be overridden")
    end

    # The name of the folder
    def export_folder_name
      return "LootTables"
    end
end
