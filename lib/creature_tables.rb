require_relative 'loot_tables'

class CreatureTables < LootTables

  private

    def base_file_data
      return {
        "$type" => "ThunderRoad.CreatureTable, ThunderRoad",
        "id" => "",
        "sensitiveContent" => "None",
        "sensitiveFilterBehaviour" => "Discard",
        "version" => 1,
        "description" => nil,
        "linkedToGenderRatio" => false,
        "minMaxDifficulty" => {
          "x" => 0,
          "y" => 0
        },
        "drops" => []
      }
    end

    # Fill the data for a table
    def create_table(file_data, ex_folder, id, table_ids, file_name)
      file_data["id"] = self.export_file_id(id)
      file_data["drops"] = []

      file_name = export_file_name(ex_folder, file_data["id"])

      # Add all the creatures that were found
      table_ids.each do |table_id|
        file_data["drops"] << {
          "$type" => "ThunderRoad.CreatureTable+Drop, ThunderRoad",
          "reference" => "Table",
          "referenceID" => table_id,
          "overrideFaction" => false,
          "factionID" => 0,
          "overrideContainer" => false,
          "overrideContainerID" => nil,
          "overrideBrain" => false,
          "overrideBrainID" => nil,
          "probabilityWeights" => [
            1,
            0,
            0,
            0,
            0
          ]
        }
        # file_data["drops"] << {
        #   "$type": "ThunderRoad.CreatureTable+Drop, ThunderRoad",
        #   "reference": "Creature",
        #   "referenceID": cr_id,
        #   "overrideFaction": false,
        #   "factionID": 0,
        #   #"overrideContainer": false,
        #   #"overrideContainerID": "",
        #   #"overrideBrain": false,
        #   #"overrideBrainID": "",
        #   "probabilityWeights": [
        #     1,
        #     0,
        #     0,
        #     0,
        #     0
        #   ]
        # }
      end

      # Save it
      save_file(file_name, file_data)
    end

    def export_file_prefix
      return 'CreatureTable'
    end

    def table_identifiers
      return [
        "MixedAll",
        "MixedMelee",
        "DungeonHumansMix"
      ]
    end

    # The file name to use
    def base_name
      return ''
    end

    # Export sub folder name
    def export_sub_folder
      return ''
    end

    def file_names_to_parse(mod_path)
      regex_to_exclude = Regexp.new((self.table_identifiers + [self.export_folder_name]).join('|'))
      return Dir["#{mod_path}/**/CreatureTable_*.json"].reject {|name| name[regex_to_exclude] }
    end

    # The name of the folder
    def export_folder_name
      return "CreatureTables_mln"
    end
end
