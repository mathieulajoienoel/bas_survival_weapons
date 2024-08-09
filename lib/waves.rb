class Waves < ModParser

  private

    def export_file_id
      return 'MixedAllFull'
    end

    def base_file_data
      return {
        "$type" => "ThunderRoad.CreatureTable, ThunderRoad",
        "id" => self.export_file_id,
        "sensitiveContent" => "None",
        "sensitiveFilterBehaviour" => "Discard",
        "version" => 1,
        "drops" => [],
        "groupPath": "Factions/Sandbox"
      }
    end

    def set_drops_in_file_data(file_data, drops)
      file_data['drops'] = drops
      return file_data
    end

    def file_name_to_create
      return 'CreatureTable_MixedAllFull.json'
    end

    def path_to_create
      return './templates/01_custom/CreatureTables'
    end

    def parse_file_data(data)
      return data['id']
    end

    def add_line(id)
      return {
        "$type" => "ThunderRoad.CreatureTable+Drop, ThunderRoad",
        "reference" => "Table",
        "referenceID" => id,
        "probabilityWeight" => 1
      }
    end

    def folders_to_parse(path)
      return [
        "#{path}/**/CreatureTable*.json",
      ]
    end
end