require 'json'
require 'fileutils'

class ModParser
  # Folder where all the Blade and Sorcery mods are.
  MOD_FOLDER = "./../"

  # The excluded mods config file
  EXCLUDED_MODS_FILENAME = "excluded_mods.json"
  # The excluded mods
  EXCLUDED_MODS = JSON.parse(File.read(EXCLUDED_MODS_FILENAME))
  EXCLUDED_MODS.map! { |x| "#{MOD_FOLDER}#{x}"  }

  def execute
    # For each mod folder
    item_ids = []
    folders = (self.mod_folders - EXCLUDED_MODS)
    puts "Found #{folders.length} folders : " + folders.inspect if !OPTIONS[:quiet]
    folders.each do |mod_path|
      # Is it a directory ?
      if !File.directory?(mod_path) || !mod_path[/^_/].nil? || EXCLUDED_MODS.include?(File.basename(mod_path))
        puts "Skipping #{mod_path}" if !OPTIONS[:quiet]
        next
      end
      # Get the item ids
      item_ids += self.parse_folder(mod_path)
    end

    puts "Found #{item_ids.length} items" if !OPTIONS[:quiet]
    return if item_ids.length == 0

    # Prepare the file data using the item_ids
    file_data = self.prepare_file_content(item_ids)

    # Create the file containing all mod data
    self.save_file(self.file_name_to_create, file_data)
  end

  private

    def mod_folders
      return Dir.glob(File.join(MOD_FOLDER, "/*"))
    end

    def set_drops_in_file_data(file_data, drops)
      return file_data
    end

    def export_file_id
      return nil
    end

    def base_file_data
      return {}
    end

    def prepare_file_content(item_ids)
      file_data = self.base_file_data
      file_data["id"] = self.export_file_id
      drops = []
      item_ids.each do |id|
        drops << self.add_line(id)
      end
      file_data = self.set_drops_in_file_data(file_data, drops)
      return file_data
    end

    def add_line(id)
      return {
        "reference" => 0,
        "referenceID" => id,
        "probabilityWeight" => 1
      }
    end

    def file_name_to_create
      return nil
    end

    def path_to_create
      return './templates/01_custom/'
    end

    def save_file(file_name, file_data)
      path = self.path_to_create
      FileUtils.mkdir_p(path)
      filename = File.join(path, file_name)
      File.write(filename, file_data.to_json)
      puts "Created #{filename}" if !OPTIONS[:quiet]
    end

    def parse_folder(path)
      file_names = []
      self.folders_to_parse(path).each do |fpath|
        file_names += Dir[fpath]
      end
      item_ids = []
      file_names.each do |fname|
        next if !fname[/_Base_/].nil?
        begin
          data = File.read(fname)
          data = JSON.parse(data)

          item_ids << self.parse_file_data(data)
        rescue StandardError => error
          puts "Failed to parse #{fname}"
          puts error.inspect
          next
        end
      end
      return item_ids
    end

    def parse_file_data(data)
      return data['id']
    end

    def folders_to_parse(path)
      return []
    end
end