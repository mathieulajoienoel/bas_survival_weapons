# Add the loot tables in each mod folder
# For each mod folder
Dir.glob(File.join(MOD_FOLDER, "/*")).each do |mod_path|
  # Is it a directory ?
  if !File.directory?(mod_path)
    puts "Skipping #{mod_path}" if !options[:quiet]
    next
  end
  # Check that we don't already have loot tables and that the marker is present
  if File.exists?(File.join(mod_path, EXPORT_FOLDER_NAME)) && !File.exists?(File.join(mod_path, EXPORT_FOLDER_NAME, MADE_BY_ME_MARKER))
    puts "Loot tables already present in #{mod_path}. Skipping" if !options[:quiet]
    next
  end

  puts "Fetching all weapon ids" if !options[:quiet]
  # Get all weapon ids from this mod
  weapon_ids = get_weapon_ids(mod_path)
  weapon_ids = filter_weapon_ids(weapon_ids)

  if weapon_ids.empty?
    puts "No weapon ids for #{mod_path}. Skipping" if !options[:quiet]
    next
  end

  if options[:print_weapon_ids]
    # Print the found weapon ids
    puts mod_path.inspect
    weapon_ids.map { |w| puts w.inspect }
    # exit 0
  else
    puts "Creating tables for #{mod_path} with #{weapon_ids.length} weapons" if !options[:quiet]
    # Create the json data for the loot tables and save the files
    create_tables(mod_path, weapon_ids)
  end
end

puts 'Done' if !options[:quiet]
