# Ruby 3.0.2
# ruby build_loot_tables.rb
# @author mathieulajoienoel

require 'json'
require 'fileutils'

MOD_FOLDER = "./../"
EXPORT_FOLDER = "LootTables"
EXCLUDED_IDS_FILENAME = "excluded_weapons.json"
EXCLUDED_WEAPONS_IDS = JSON.parse(File.read(EXCLUDED_IDS_FILENAME))
EXCLUDED_WEAPONS_IDS.map!(&:downcase)

# Get all weapon ids
weapon_ids = []
Dir["#{MOD_FOLDER}/**/Item_Weapon_*.json"].each do |fname|
  begin
    data = JSON.parse(File.read(fname))
    weapon_ids << data['id'] if !data["id"].nil?
  rescue StandardError => error
    puts "Failed to parse #{fname}"
    puts error.inspect
    next
  end
end

# Filter the weapons
weapon_ids = weapon_ids - EXCLUDED_WEAPONS_IDS

weapon_ids.each_with_index do |wid, i|
  weapon_ids[i] = nil if EXCLUDED_WEAPONS_IDS.include?(wid.downcase)
end
# Make sure we only have unique entries
weapon_ids = weapon_ids.compact.uniq

# weapon_ids.map { |w| puts w.inspect }
# exit

# Setup the base file contents
FileUtils.mkdir_p(EXPORT_FOLDER) if !File.exists?(EXPORT_FOLDER)
file_data = {
  "$type" => "ThunderRoad.LootTable, Assembly-CSharp",
  "id" => "",
  "saveFolder" => "Bas",
  "version" => 1,
  "drops" => []
}
file_name = ""
(1..10).to_a.each do |i|
  file_data["id"] = "SurvivalRewards#{i}"
  file_data["drops"] = []

  file_name = File.join(EXPORT_FOLDER, "LootTable_SurvivalRewards#{i}.json")

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

puts 'done'
