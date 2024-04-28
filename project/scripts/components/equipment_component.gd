# Currently only manages current equipped item

class_name EquipmentComponent
extends Node

# may be useful to promote items to no longer being an inner class, might improve linting
var equipped_item: String
var game_ui: GameUIController

func get_equipped_item():
	return equipped_item

func initialize(ui: GameUIController):
	game_ui = ui
	game_ui.item_equipped.connect(equip_item)

# Replace the currently equipped item with the new item
func equip_item(new_item: String):
	print("Current item: ", equipped_item, " New item: ", new_item)
	var old_item = equipped_item
	
	# if no item was equipped before, just equip the new item
	# if an item was equipped before, unequip the old item and equip the new item
	# if the same item is equipped, unequip the item
	if old_item == "":
		game_ui.set_equipped_item(new_item)
		equipped_item = new_item
	elif old_item == new_item:
		game_ui.set_equipped_item("")
		equipped_item = ""
	else:
		game_ui.set_equipped_item(new_item)
		equipped_item = new_item