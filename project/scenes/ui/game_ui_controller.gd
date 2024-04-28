class_name GameUIController
extends CanvasLayer

# TODO: I don't like threading this throuhg the inventory controller for no reason
signal item_equipped(item_id: String)
signal item_consumed(item_id: String)

const texture_template = "res://project/textures/items/%s.png"

@onready var hp_progress_bar: TextureProgressBar = %HPProgressBar
@onready var energy_progress_bar: TextureProgressBar = %EnergyProgressBar
@onready var icon: Sprite2D = %Icon
@onready var inventory_screen = %InventoryScreen
@onready var equipped_icon: TextureRect = %EquippedItemIcon

var max_hp: float = 0
var max_energy: float = 0

var hp: int = 0
var energy: int = 0

func _ready():
	inventory_screen.item_selected.connect(on_item_selected)

# Separating from _ready() allows this to be called after everything else is ready
func initialize(max_health, maximum_energy):
	print("Initializing Game UI: max_health: ", max_health, " maximum_energy: ", maximum_energy)
	max_hp = max_health
	max_energy = maximum_energy
	hp_progress_bar.max_value = max_hp
	energy_progress_bar.max_value = max_energy
	set_hp(max_hp)
	set_energy(max_energy)

func set_hp(new_hp: float) -> void:
	hp_progress_bar.value = new_hp
	if new_hp < 0:
		new_hp = 0
	icon.frame = int(lerp(5, 0, new_hp / max_hp))

func set_energy(new_energy: float) -> void:
	energy_progress_bar.value = new_energy

func on_item_selected(item_id: String):
	# infer the result of clicking this item, TODO: Code smell?
	if Items.is_equippable(item_id):
		item_equipped.emit(item_id)
	elif Items.is_consumable(item_id):
		item_equipped.emit(item_id)

func set_equipped_item(item_name: String):
	print("UI - Updating equipped item: ", item_name)
	if item_name == "":
		equipped_icon.texture = null
	else:
		equipped_icon.texture = load(texture_template % item_name)