extends Node

@export var items: Dictionary = {}
var player_items: Dictionary = {}
var player_equipped = []

func _ready():
	load_items()

func load_items():
	var file = FileAccess.open("res://project/data/items.json", FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	items = data["items"]
	file.close()

func add_item(item:String, quantity:int = 1) -> int:
	if item not in items:
		print("add_item: invalid item ", item)
		return -1

	if player_items.has(item):
		player_items[item] += quantity
	else:
		player_items[item] = quantity
	return quantity


func remove_item(item:String, quantity: int = 1) -> int:
	if item not in items:
		print("remove_item: invalid item ", item)
		return -1
	
	if player_items.has(item) and player_items[item] >= quantity:
		player_items[item] -= quantity
		if player_items[item] <= 0:
			player_items.erase(item)
			return 0
		return player_items[item]
	return -1
	
func get_quantity(item:String) -> int:
	if item not in items:
		print("get_quantity: invalid item ", item)
		return -1
	return player_items.get(item, 0)
