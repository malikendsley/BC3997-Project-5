extends Node

@export var items: Dictionary = {}

#enum ItemType {
#	WEAPON,
#	RESOURCE
#}

#class ItemClass:
#	var id: String
#	var item_name: String
#	var item_type: ItemType
#	var recipe: ItemClass
#	var is_craftable: bool
#	var is_equippable: bool

func _ready():
	load_items()

func load_items():
	var file = FileAccess.open("res://project/data/items.json", FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	#print(data["items"])
	items = data
	file.close()
