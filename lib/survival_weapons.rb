require_relative 'loot_tables'

class SurvivalWeapons < LootTables

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

    def use_categories
      return false
    end
end
