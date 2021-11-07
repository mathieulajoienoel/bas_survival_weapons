# Ruby 3.0.2
# ruby remove_loot_tables.rb
# @author mathieulajoienoel

# require 'json'
require 'fileutils'

MOD_FOLDER = "./../"
EXPORT_FOLDER_NAME = "LootTables"
MADE_BY_ME_MARKER = "managed_by_mln"

# Get all mod folders
files_to_remove = []
Dir.glob(File.join(MOD_FOLDER, "/*")).each do |mod_path|
  next if !File.directory?(mod_path)
  loot_table_folder_path = File.join(mod_path, EXPORT_FOLDER_NAME)
  # puts File.chmod(0777, loot_table_folder_path).inspect
  marker_file_path = File.join(loot_table_folder_path, MADE_BY_ME_MARKER)
  next if !(File.exists?(loot_table_folder_path) && File.exists?(marker_file_path))
  files_to_remove << loot_table_folder_path
end

files_to_remove.map {|f| puts f.inspect }
# exit
puts "Do you want to remove these folders (Y/n)"
ans = gets.chomp
if ans == "Y"
  files_to_remove.each do |fname|
    FileUtils.rm_rf(fname)
    puts "Removed #{fname}"
  end
end

puts 'done'
