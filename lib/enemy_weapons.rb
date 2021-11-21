require_relative 'loot_tables'

class EnemyWeapons < LootTables

  private

    def table_identifiers
      return ['Weapon1H', 'Weapon2H', 'ShieldMisc']
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


