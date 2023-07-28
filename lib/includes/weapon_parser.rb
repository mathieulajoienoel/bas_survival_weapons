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

  def get_weapon_ids(mod_path, use_categories: false)
    # Get all weapon ids
    weapon_ids = []
    @weapon_categories = self.weapon_categories if use_categories
    file_names_to_parse(mod_path).each do |fname|
      begin
        data = JSON.parse(File.read(fname))
        @weapon_categories = self.set_in_category(@weapon_categories, data) if use_categories
        weapon_ids << data['id'] if !data["id"].nil?
      rescue StandardError => error
        puts "Failed to parse #{fname}"
        puts error.inspect
        next
      end
    end
    return weapon_ids
  end

  def weapon_categories
    @weapon_categories = table_identifiers.map {|x| [x, []]}.to_h
  end

  def set_in_category(categories, weapon)
    return categories if weapon['modules'].empty? || categories.empty?
    case weapon['modules'][0]['weaponClass']
    when "Melee"
      if weapon['modules'][0]['weaponHandling'] == "OneHanded"
        categories['Weapon1H'] << weapon['id']
      else
        categories['Weapon2H'] << weapon['id']
      end
    when "Shield"
      categories['ShieldMisc'] << weapon['id']
    # else
    #   categories['WeaponRand'] << weapon['id']
    end
    categories['WeaponRand'] << weapon['id']
    return categories
  end

  private

    def file_names_to_parse(mod_path)(mod_path)
      return Dir["#{mod_path}/**/Item_Weapon_*.json"] + Dir["#{mod_path}/**/Item_Shield_*.json"] + Dir["#{mod_path}/**/Item_Arrow_*.json"]
    end

end
