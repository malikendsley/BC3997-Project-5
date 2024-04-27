extends Node

@export var items: Dictionary = {}

# Add an item by item id ("wood", "stone", etc.) to the player's inventory.
# Returns the number of that item the player has after added, -1 if unsuccessful.
func add_item(item:String, quantity:int = 1) -> int:
	if !Items.is_item(item):
		print("add_item: invalid item ", item)
		return -1

	if items.has(item):
		items[item] += quantity
	else:
		items[item] = quantity
	return quantity

# Remove an item by item id ("wood", "stone", etc.) from the player's inventory.
# Returns the number of that item the player has after removed, 
# -1 if unsuccessful or player does not have enough of that item to remove.
func remove_item(item:String, quantity: int = 1) -> int:
	if !Items.is_item(item):
		print("remove_item: invalid item ", item)
		return -1
	
	if items.has(item) and items[item] >= quantity:
		items[item] -= quantity
		if items[item] <= 0:
			items.erase(item)
			return 0
		return items[item]
	return -1

# Gets the number of some item currently in the user's inventory
func get_quantity(item:String) -> int:
	if !Items.is_item(item):
		print("get_quantity: invalid item ", item)
		return -1
	return items.get(item, 0)

# Returns true if a user has at least one item, false otherwise
func has_item(item: String) -> bool:
	return get_quantity(item) >= 1

# Returns true if item is craftable with the items the user currently possesses, false otherwise.
func can_craft(item: String) -> bool:
	var recipe:Dictionary = Items.get_recipe(item)
	for i in recipe:
		if get_quantity(i) < recipe[i]:
			return false
	return true
