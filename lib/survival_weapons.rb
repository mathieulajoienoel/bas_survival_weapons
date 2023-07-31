require_relative 'loot_tables'

class SurvivalWeapons < LootTables

  private

    def base_file_data
      return {
        "$type" => "ThunderRoad.LootTable, ThunderRoad",
        "id" => "",
        "sensitiveContent" => "None",
        "sensitiveFilterBehaviour" => "Discard",
        "version" => 1,
        "groupPath" => "Rewards/Survival",
        "drops" => []
      }
    end

    def export_file_prefix
      return 'LootTable'
    end

    def table_identifiers
      return (1..10).to_a
    end

    # The file name to use
    def base_name
      return 'SurvivalRewards'
    end

    # Export sub folder name
    def export_sub_folder
      return '' # 'SurvivalLoot'
    end

    def use_categories
      return false
    end

    # The name of the folder
    def export_folder_name
      return "LootTables_mln"
    end
end
