require_relative 'loot_tables'

class EnemyWeapons < LootTables

  def initialize
    self.weapon_categories
  end

  private

    def use_categories
      return true
    end

    # Fill the data for a table
    def create_table(file_data, ex_folder, id, weapon_ids, file_name)
      file_data["id"] = self.export_file_id(id)
      file_data["drops"] = []

      file_name = export_file_name(ex_folder, file_data["id"])
      if @weapon_categories[id].empty?
        puts "No weapons for #{id}" if !OPTIONS[:quiet]
        return
      end
      # Add all the weapons that were found
      @weapon_categories[id].each do |wep_id|
        file_data["drops"] << {
          "reference" => 0,
          "referenceID" => wep_id,
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
end


