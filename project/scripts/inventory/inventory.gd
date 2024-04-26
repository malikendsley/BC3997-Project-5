extends Node

@export var items: Dictionary = {}
var player_equipped = []

func add_item(item:String, quantity:int = 1) -> int:
	if item not in Items.items:
		print("add_item: invalid item ", item)
		return -1

	if items.has(item):
		items[item] += quantity
	else:
		items[item] = quantity
	return quantity


func remove_item(item:String, quantity: int = 1) -> int:
	if item not in Items.items:
		print("remove_item: invalid item ", item)
		return -1
	
	if items.has(item) and items[item] >= quantity:
		items[item] -= quantity
		if items[item] <= 0:
			items.erase(item)
			return 0
		return items[item]
	return -1
	
func get_quantity(item:String) -> int:
	if item not in Items.items:
		print("get_quantity: invalid item ", item)
		return -1
	return items.get(item, 0)
