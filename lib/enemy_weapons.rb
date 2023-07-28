require_relative 'loot_tables'

class EnemyWeapons < LootTables

  def initialize
    self.item_categories
  end

  private

    def export_file_prefix
      return 'LootTable'
    end

    def base_file_data
      return {
        "$type": "ThunderRoad.LootTable, ThunderRoad",
        "id": "",
        "sensitiveContent": "None",
        "sensitiveFilterBehaviour": "Discard",
        "version": 1,
        "groupPath": "Weapons",
        "drops": []
      }
    end

    def use_categories
      return true
    end

    # Fill the data for a table
    def create_table(file_data, ex_folder, id, item_ids, file_name)
      file_data["id"] = self.export_file_id(id)
      file_data["drops"] = []

      file_name = export_file_name(ex_folder, file_data["id"])
      if @item_categories[id].empty?
        puts "No items for #{id}" if !OPTIONS[:quiet]
        return
      end
      # Add all the items that were found
      @item_categories[id].each do |item_id|
        file_data["drops"] << {
          "reference" => 0,
          "referenceID" => item_id,
          "probabilityWeight" => self.probability_weight
        }
      end

      # Save it
      save_file(file_name, file_data)
    end

    def table_identifiers
      return ['Weapon1H', 'Weapon2H', 'ShieldMisc', 'WeaponRand']
      # ['ShieldMisc', 'Weapon1H', 'Weapon2H', 'WeaponAxe', 'WeaponDagger', 'WeaponMace', 'WeaponStaff', 'WeaponSword']
    end

    # The file name to use
    def base_name
      return ''
    end

    # Export sub folder name
    def export_sub_folder
      return '' # 'EnemyWeapons'
    end

    # The name of the folder
    def export_folder_name
      return "LootTables_mln"
    end

end


