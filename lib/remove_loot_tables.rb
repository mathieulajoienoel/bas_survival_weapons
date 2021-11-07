# If the user has selected to remove the tables
if options[:remove]
  # Get all mod folders
  to_remove = []
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
    to_remove << loot_table_folder_path
  end

  # Give the user a chance to review the files to delete
  if !options[:quiet]
    puts "Folders that will be removed :"
    to_remove.map {|f| puts f.inspect }
  end
  # Get the users answer
  if !options[:force_yes]
    puts "Do you want to remove these folders (Y/n)"
    ans = gets.chomp
  else
    ans = "Y"
  end

  # Remove the files
  if ans == "Y"
    to_remove.each do |fname|
      FileUtils.rm_rf(fname)
      puts "Removed #{fname}" if !options[:quiet]
    end
  end

  puts 'Done' if !options[:quiet]
  exit 0
end
