extends Node

# Enum for item types
enum Type {UNDEFINED,
	RESOURCE,
	WEAPON,
	ITEM}

# Inner Item class
class Item:
	var id: String = ""
	var item_name: String = ""
	var type: Type = Type.RESOURCE
	var recipe: Dictionary = {}
	var is_craftable: bool = false
	var is_equippable: bool = false
	var is_consumable: bool = false
	var effects = {}
	var stats = {}
	
	func _to_string():
		return "id: " + id + ", name: " + item_name + ", type: " + str(Type.keys()[type]) + ", recipe: " + str(recipe) + ", is_craftable: " + str(is_craftable) + ", is_equippable: " + str(is_equippable)

# items dictionary that holds every item in the game. Key is item id (string), value is an item object of the Item class
@export var items: Dictionary = {}
@export var loot_lookup: Dictionary = {}

# Returns true if item is valid in the game, false otherwise.
func is_item(item: String) -> bool:
	return items.has(item)

# Gets the item's printable name from the item id.
func get_item_name(item: String):
	if !is_item(item):
		return null
	return items[item].item_name

# Gets the item's type
func get_type(item: String):
	if !is_item(item):
		return null
	return items[item].type

# Gets the item's recipe
func get_recipe(item: String):
	if !is_item(item):
		return null
	return items[item].recipe

# Returns true if item is craftable, false otherwise.
func is_craftable(item: String):
	if !is_item(item):
		return null
	return items[item].is_craftable

# Returns true if item is equippable, false otherwise.
func is_equippable(item: String):
	if !is_item(item):
		return null
	return items[item].is_equippable

# Returns true if the item is consumable, false otherwise.
func is_consumable(item: String):
	if !is_item(item):
		return null
	return items[item].is_consumable

# Returns the effects of the item if it is consumable, null otherwise.
func get_effects(item: String):
	if !is_item(item) or !items[item].is_consumable:
		return null
	return items[item].effects

# Returns the stats of the item if it is equippable, null otherwise.
func get_stats(item: String):
	if !is_item(item) or !items[item].is_equippable:
		return null
	return items[item].stats

func roll_loot_table(enemy_id: String) -> String:
	if !loot_lookup.has(enemy_id):
		push_error("Error: Loot table for enemy " + enemy_id + " does not exist.")
		return ""
	var loot_table = loot_lookup[enemy_id]
	# the loot table is stored as a dictionary of item_id -> probability mappings,
	# with no drop as an implicit probability of 1 - sum of all other probabilities
	var prob = randf()
	var cumulative_prob = 0.0
	for item in loot_table:
		cumulative_prob += loot_table[item]
		if prob <= cumulative_prob:
			return item
	return ""

func _ready():
	_load_items()
	_load_loot()
	
func _type_str_to_enum(s: String):
	var type_enum = Type.get(s.to_upper())
	if type_enum == null:
		return Type.UNDEFINED
	return type_enum

func _get_recipe_dictionary(recipe):
	if recipe == null:
		return {}

	var res: Dictionary = {}
	for item in recipe:
		if res.has(item):
			res[item] += 1
		else:
			res[item] = 1
	return res
	
func _create_item_object(json_data):
	var item_object = Item.new()
	
	item_object.id = json_data["id"]
	item_object.item_name = json_data["name"]
	item_object.type = _type_str_to_enum(json_data["type"])
	item_object.recipe = _get_recipe_dictionary(json_data["recipe"])
	item_object.is_craftable = (json_data["recipe"] != null)
	item_object.is_equippable = json_data["is_equippable"]
	if item_object.is_equippable:
		item_object.stats = json_data["stats"]
	item_object.is_consumable = json_data.has("effects")
	if item_object.is_consumable:
		item_object.effects = json_data["effects"]
	
	return item_object

# TODO: Can create a more elaborate system later
func _create_loot_table(json_data):
	var prob = 1.0
	for item in json_data:
		var chance = json_data[item]
		prob -= chance
	if prob < 0:
		push_error("Error: Loot table probabilities do not add up to 1.")
		return null
	return json_data

func _load_items():
	var file = FileAccess.open("res://project/data/items.json", FileAccess.READ)
	var content = file.get_as_text()
	var json_data = JSON.parse_string(content)
	file.close()
	
	for key in json_data["items"]:
		var item_object = _create_item_object(json_data["items"][key])
		items[key] = item_object

func _load_loot():
	var file = FileAccess.open("res://project/data/loot_tables.json", FileAccess.READ)
	var content = file.get_as_text()
	var json_data = JSON.parse_string(content)
	file.close()

	for key in json_data["loot"]:
		loot_lookup[key] = _create_loot_table(json_data["loot"][key])