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
  Dir["#{mod_path}/**/Item_Weapon_*.json"].each do |fname|
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
  FileUtils.touch(File.join(export_folder, MADE_BY_ME_MARKER)) if options[:add_marker]
end
