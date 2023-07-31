module ItemParser
  # The excluded items config file
  EXCLUDED_IDS_FILENAME = "excluded_items.json"
  # The excluded item ids
  EXCLUDED_ITEMS_IDS = JSON.parse(File.read(EXCLUDED_IDS_FILENAME))
  EXCLUDED_ITEMS_IDS.map!(&:downcase)

  def filter_item_ids(item_ids)
    # Filter the items
    item_ids = item_ids - EXCLUDED_ITEMS_IDS
    item_ids.each_with_index do |wid, i|
      item_ids[i] = nil if EXCLUDED_ITEMS_IDS.include?(wid.downcase)
    end
    # Make sure we only have unique entries
    return item_ids.compact.uniq
  end

  def get_item_ids(mod_path, use_categories: false)
    # Get all item ids
    item_ids = []
    @item_categories = self.item_categories if use_categories
    file_names_to_parse(mod_path).each do |fname|
      begin
        data = JSON.parse(File.read(fname))
        @item_categories = self.set_in_category(@item_categories, data) if use_categories
        item_ids << data['id'] if !data["id"].nil?
      rescue StandardError => error
        puts "Failed to parse #{fname}"
        puts error.inspect
        next
      end
    end
    return item_ids
  end

  def item_categories
    @item_categories = table_identifiers.map {|x| [x, []]}.to_h
  end

  def set_in_category(categories, item)
    return categories if item['modules'].empty? || categories.empty?
    case item['modules'][0]['itemClass']
    when "Melee"
      if item['modules'][0]['itemHandling'] == "OneHanded"
        categories['Weapon1H'] << item['id']
      else
        categories['Weapon2H'] << item['id']
      end
    when "Shield"
      categories['ShieldMisc'] << item['id']
    # else
    #   categories['WeaponRand'] << item['id']
    end
    categories['WeaponRand'] << item['id']
    return categories
  end

  private

    def file_names_to_parse(mod_path)
      fnames = []
      [
        "#{mod_path}/**/Item_Weapon_*.json",
        "#{mod_path}/**/Item_Shield_*.json",
        "#{mod_path}/**/Item_Arrow_*.json",
        "#{mod_path}/**/Item_Lightsaber_*.json",
        "#{mod_path}/**/Item_Blaster_*.json"
      ].each do |fpath|
        fnames += Dir[fpath]
      end
      return fnames
    end

end
