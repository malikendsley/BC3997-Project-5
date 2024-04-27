class_name GameUIController
extends CanvasLayer

@onready var hp_progress_bar: TextureProgressBar = %HPProgressBar
@onready var energy_progress_bar: TextureProgressBar = %EnergyProgressBar
@onready var icon: Sprite2D = %Icon

var max_hp: float = 0
var max_energy: float = 0

var hp: int = 0
var energy: int = 0

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

# TODO: For testing, called by a button, remove later
func _damage_all_enemies():
	print("damaging all enemies")
	# get all entities and hit them with player damage, won't hurt the player
	for enemy in get_tree().get_nodes_in_group("entities"):
		print("Entity: ", enemy.name)
		var damage_instance = DamageInstance.new(1, DamageInstance.Faction.PLAYER, self, Vector2(0, 0))
		enemy.hurt_component.send_damage(damage_instance)
