class LootTables < ModParser

  private

    def export_file_id
      return 'AllSurvivalRewards'
    end

    def base_file_data
      return {
        "$type" => "ThunderRoad.LootTable, ThunderRoad",
        "id" => self.export_file_id,
        "sensitiveContent" => "None",
        "sensitiveFilterBehaviour" => "Discard",
        "version" => 1,
        "levelledDrops" => [
          {
            "$type" => "ThunderRoad.LootTable+DropLevel, ThunderRoad",
            "dropLevel" => 0,
            "drops" => []
          }
        ],
        "groupPath" => "Rewards/Survival"
      }
    end

    def set_drops_in_file_data(file_data, drops)
      file_data['levelledDrops'][0]['drops'] = drops
      return file_data
    end

    def file_name_to_create
      return 'LootTable_AllSurvivalRewards.json'
    end

    def path_to_create
      return './templates/01_custom/LootTables'
    end

    def parse_file_data(data)
      return data['id']
    end

    def folders_to_parse(path)
      return [
        "#{path}/**/Item_Weapon_*.json",
        "#{path}/**/Item_Shield_*.json",
        "#{path}/**/Item_Arrow_*.json",
        "#{path}/**/Item_Lightsaber_*.json",
        "#{path}/**/Item_Blaster_*.json"
      ]
    end
end