extends Node

var items : Dictionary = {}

func add_item(item:String, quantity:int = 1) -> int:
	if items.has(item):
		items[item] += quantity
	else:
		items[item] = quantity
	return quantity


func remove_item(item:String, quantity: int = 1) -> int:
	if items.has(item) and items[item] >= quantity:
		items[item] -= quantity
		if items[item] <= 0:
			items.erase(item)
			return 0
		return items[item]
	return -1
	
func get_quantity(item:String) -> int:
	return items.get(item, 0)
