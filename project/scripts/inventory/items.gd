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
	
	func _init():
		pass
	
	func _to_string():
		return "id: " + id + ", name: " + item_name + ", type: " + str(Type.keys()[type]) + ", recipe: " + str(recipe) + ", is_craftable: " + str(is_craftable) + ", is_equippable: " + str(is_equippable)

# items dictionary that holds every item in the game. Key is item id (string), value is an item object of the Item class
@export var items: Dictionary = {}

# Returns true if item is valid in the game, false otherwise.
func is_item(item:String) -> bool:
	return items.has(item)

# Gets the item's printable name from the item id.
func get_item_name(item:String):
	if !is_item(item):
		return null
	return items[item].item_name

# Gets the item's type
func get_type(item:String):
	if !is_item(item):
		return null
	return items[item].type

# Gets the item's recipe
func get_recipe(item:String):
	if !is_item(item):
		return null
	return items[item].recipe

# Returns true if item is craftable, false otherwise.
func is_craftable(item:String):
	if !is_item(item):
		return null
	return items[item].is_craftable

# Returns true if item is equippable, false otherwise.
func is_equippable(item: String):
	if !is_item(item):
		return null
	return items[item].is_equippable

func _ready():
	load_items()
	
func type_str_to_enum(s:String):
	var type_enum = Type.get(s.to_upper())
	if type_enum == null:
		return Type.UNDEFINED
	return type_enum

func get_recipe_dictionary(recipe):
	if recipe == null:
		return {}

	var res: Dictionary = {}
	for item in recipe:
		if res.has(item):
			res[item] += 1
		else:
			res[item] = 1
	return res
	
func create_item_object(json_data):
	var item_object = Item.new()
	
	item_object.id = json_data["id"]
	item_object.item_name = json_data["name"]
	item_object.type = type_str_to_enum(json_data["type"])
	item_object.recipe = get_recipe_dictionary(json_data["recipe"])
	item_object.is_craftable = (json_data["recipe"] != null)
	item_object.is_equippable = json_data["is_equippable"]
	
	return item_object

func load_items():
	var file = FileAccess.open("res://project/data/items.json", FileAccess.READ)
	var content = file.get_as_text()
	var json_data = JSON.parse_string(content)
	file.close()
	
	for key in json_data["items"]:
		var item_object = create_item_object(json_data["items"][key])
		items[key] = item_object
