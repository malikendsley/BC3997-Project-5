# Manages the player's held item and its use

class_name EquipmentComponent
extends Node2D

const texture_template = "res://project/textures/items/%s.png"

signal equipment_finished()
@onready var uphit: CollisionPolygon2D = %UPoly
@onready var downhit: CollisionPolygon2D = %DPoly
@onready var lefthit: CollisionPolygon2D = %LPoly
@onready var righthit: CollisionPolygon2D = %RPoly
@export var anim_player: AnimationPlayer
@export var player: Player
@export var item_sprite: Sprite2D
var base_swing_cd: float = 0.33

var equipped_item: String:
	set(new_item):
		if new_item == "":
			damage = 1
			equipment_cooldown = 0.33
			item_sprite.texture = null
		else:
			damage = Items.get_stats(new_item).damage
			equipment_cooldown = Items.get_stats(new_item).cooldown
			item_sprite.texture = load(texture_template % new_item)
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

func _ready():
	# shut off the hitboxes
	_clear_hitboxes()
	item_sprite.texture = null

func _process(delta):
	# tick down the equipment timer
	if equipment_timer > 0:
		equipment_timer -= delta
		if equipment_timer <= 0:
			print("Equipment cooled off")
			equipment_timer = 0
			_play_animation("RESET")
			_clear_hitboxes()
			await anim_player.animation_finished
			equipment_finished.emit()

func equip_item(new_item: String):
	assert(Items.is_item(new_item), "Invalid item: " + new_item)
	assert(Items.is_equippable(new_item), "Invalid item: " + new_item)
	# Previously nothing equipped
	if equipped_item == "":
		game_ui.set_equipped_item(new_item)
		equipped_item = new_item

	# Dequipping
	elif equipped_item == new_item:
		game_ui.set_equipped_item("")
		equipped_item = ""

	# Equipping a new item
	else:
		game_ui.set_equipped_item(new_item)
		equipped_item = new_item

	# Update the hit boxes
	for hitbox in [uphit, downhit, lefthit, righthit]:
		hitbox.get_parent().damage = damage

# Returns true if the equipment was used
func use_equipment(location: Vector2) -> bool:
	if equipment_timer > 0:
		return false
	equipment_timer = equipment_cooldown
	var direction = (location - global_position).normalized()

	# Determine the direction and perform action based on the quadrant
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			_play_animation("swing_right")
			righthit.disabled = false
		else:
			_play_animation("swing_left")
			lefthit.disabled = false
	else:
		if direction.y > 0:
			_play_animation("swing_down")
			downhit.disabled = false
		else:
			_play_animation("swing_up")
			uphit.disabled = false

	return true

func _play_animation(anim_name: String):
	# the base speed on swinging animations is 0.33 seconds, so scale it to the cooldown
	anim_player.play(anim_name, -1, base_swing_cd / equipment_cooldown)

func _clear_hitboxes():
	for hitbox in [uphit, downhit, lefthit, righthit]:
		hitbox.disabled = true
