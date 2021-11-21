module WeaponParser
  # The excluded weapons config file
  EXCLUDED_IDS_FILENAME = "excluded_weapons.json"
  # The excluded weapon ids
  EXCLUDED_WEAPONS_IDS = JSON.parse(File.read(EXCLUDED_IDS_FILENAME))
  EXCLUDED_WEAPONS_IDS.map!(&:downcase)

  def filter_weapon_ids(weapon_ids)
    # Filter the weapons
    weapon_ids = weapon_ids - EXCLUDED_WEAPONS_IDS
    weapon_ids.each_with_index do |wid, i|
      weapon_ids[i] = nil if EXCLUDED_WEAPONS_IDS.include?(wid.downcase)
    end
    # Make sure we only have unique entries
    return weapon_ids.compact.uniq
  end

  def get_weapon_ids(mod_path)
    # Get all weapon ids
    weapon_ids = []
    weapon_files = Dir["#{mod_path}/**/Item_Weapon_*.json"] + Dir["#{mod_path}/**/Item_Shield_*.json"] + Dir["#{mod_path}/**/Item_Arrow_*.json"]
    weapon_files.each do |fname|
      begin
        data = JSON.parse(File.read(fname))
        weapon_ids << data['id'] if !data["id"].nil?
      rescue StandardError => error
        puts "Failed to parse #{fname}"
        puts error.inspect
        next
      end
    end
    return weapon_ids
  end

  def get_weapon_type
  end

  def weapon_categories
    @weapon_categories ||= Hash.new(table_identifiers.keys.map {|x| [x, []]})
  end

  def set_in_category(categories, weapon)
    case weapon['modules']['weaponClass']
    when "Melee"
      if weapon['modules']['weaponHandling'] == "OneHanded"
        categories['Weapon1H'] << data['id']
      else
        categories['Weapon2H'] << data['id']
      end
    when "Shield"
      categories['ShieldMisc'] << data['id']
    end
    return categories
  end

end
