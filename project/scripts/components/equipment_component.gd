# Currently only manages current equipped item

class_name EquipmentComponent
extends Node

signal equipment_finished()

var equipped_item: String:
	set(new_item):
		if new_item == "":
			damage = 1
			equipment_cooldown = 0.33
		else:
			damage = Items.get_stats(new_item).damage
			equipment_cooldown = Items.get_stats(new_item).cooldown
		equipped_item = new_item
		print("Equipped: " + equipped_item if equipped_item != "" else "hands" + " Damage: " + str(damage) + " Cooldown: " + str(equipment_cooldown))
var game_ui: GameUIController
var equipment_timer: float = 0
var equipment_cooldown: float = 0.5
var damage: int = 1 # default for hands

func get_equipped_item():
	return equipped_item

func initialize(ui: GameUIController):
	game_ui = ui
	game_ui.item_equipped.connect(equip_item)

func _process(delta):
	# tick down the equipment timer
	if equipment_timer > 0:
		equipment_timer -= delta
		if equipment_timer <= 0:
			equipment_timer = 0

func equip_item(new_item: String):
	assert(Items.is_item(new_item), "Invalid item: " + new_item)
	assert(Items.is_equippable(new_item), "Invalid item: " + new_item)
	# Previously nothing equipped
	if equipped_item == "":
		game_ui.set_equipped_item(new_item)
		equipped_item = new_item
		return

	# Dequipping
	if equipped_item == new_item:
		game_ui.set_equipped_item("")
		equipped_item = ""
		return

	# Equipping a new item
	game_ui.set_equipped_item(new_item)
	equipped_item = new_item
	return

# Returns true if the equipment was used
func use_equipment(location: Vector2) -> bool:
	if equipment_timer > 0:
		return false
	#TODO
	return true
	