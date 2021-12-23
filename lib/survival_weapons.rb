require_relative 'loot_tables'

class SurvivalWeapons < LootTables

  USE_CATEGORIES = false

  private

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
end
