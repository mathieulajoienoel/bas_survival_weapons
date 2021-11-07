# Folder where all the Blade and Sorcery mods are.
MOD_FOLDER = "./../"
# The name ot the LootTables folder
EXPORT_FOLDER_NAME = "LootTables"
# The excluded weapons config file
EXCLUDED_IDS_FILENAME = "excluded_weapons.json"
# The excluded weapon ids
EXCLUDED_WEAPONS_IDS = JSON.parse(File.read(EXCLUDED_IDS_FILENAME))
EXCLUDED_WEAPONS_IDS.map!(&:downcase)
# File marker name
MADE_BY_ME_MARKER = "managed_by_mln"
