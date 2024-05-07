class_name Inventory
extends Node2D

signal refresh_inventory

var items: Dictionary = {}
const LOOT_SPLASH_RADIUS = 50
@export var item_pickup: PackedScene

# Add an item by item id ("wood", "stone", etc.) to the player's inventory.
# Returns the number of that item the player has after added, -1 if unsuccessful.
func add_item(item: String, quantity: int=1) -> int:
	if !Items.is_item(item):
		print("add_item: invalid item ", item)
		return - 1

	if items.has(item):
		items[item] += quantity
	else:
		items[item] = quantity
	refresh_inventory.emit()
	return quantity

# Remove an item by item id ("wood", "stone", etc.) from the player's inventory.
# Returns the number of that item the player has after removed, 
# -1 if unsuccessful or player does not have enough of that item to remove.
func remove_item(item: String, quantity: int=1) -> int:
	if !Items.is_item(item):
		print("remove_item: invalid item ", item)
		return - 1
	
	var res: int = -1
	if items.has(item) and items[item] >= quantity:
		items[item] -= quantity
		if items[item] <= 0:
			items.erase(item)
			res = 0
		else:
			res = items[item]
	
	refresh_inventory.emit()
	return res

# Gets the number of some item currently in the user's inventory
func get_quantity(item: String) -> int:
	if !Items.is_item(item):
		print("get_quantity: invalid item ", item)
		return - 1
	return items.get(item, 0)

# Returns true if a user has at least one item, false otherwise
func has_item(item: String) -> bool:
	return get_quantity(item) >= 1

# Returns true if item is craftable with the items the user currently possesses, false otherwise.
func can_craft(item: String) -> bool:
	if !Items.is_item(item):
		print("can_craft: invalid item ", item)
		return false
	var recipe: Dictionary = Items.get_recipe(item)
	for i in recipe:
		if get_quantity(i) < recipe[i]:
			return false
	return true

# Crafts an item (takes away item's recipe from inventory; adds that crafted item)
func craft(item: String) -> bool:
	if !Items.is_item(item):
		print("craft: invalid item ", item)
		return false
	if not can_craft(item):
		return false
	
	var recipe: Dictionary = Items.get_recipe(item)
	for i in recipe:
		remove_item(i, recipe[i])
	add_item(item)
	refresh_inventory.emit()
	return true

# Get a frequency table of all items in this inventory
func get_all_items() -> Dictionary:
	var all_items: Dictionary = {}
	for i in items:
		all_items[i] = get_quantity(i)
	return all_items

# Drop this inventory onto the ground
# TODO: Separate into a new component?
func drop_inventory_on_ground():
	for i in items:
		for j in range(items[i]):
			# pick random point at LOOT_SPLASH_RADIUS
			var angle = randf() * 2 * PI
			var destination = Vector2(global_position.x + cos(angle) * LOOT_SPLASH_RADIUS, global_position.y + sin(angle) * LOOT_SPLASH_RADIUS)
			# create item entity
			var item = item_pickup.instantiate() as ItemPickup
			item.collectible = false
			item.update_item(i)
			item.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", item)
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).tween_property(item, "global_position", destination, 0.5)
			tween.tween_callback(item.set_collectible.bind(true))
			remove_item(i)