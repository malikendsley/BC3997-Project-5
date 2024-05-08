# Specific stat component for the player

class_name PlayerStatComponent
extends StatComponent

signal energy_changed(new_energy: float)
signal no_energy()

@export var max_energy: float = 100

# How long the max energy will last in seconds
# (Base because energy cap may change, but this should not)
@export var base_energy_time: float = 90
@onready var energy_tick_rate: float = base_energy_time / max_energy

var current_energy: float:
	set(new_energy):
		if current_energy != new_energy:
			current_energy = clamp(new_energy, 0, max_energy)
			energy_changed.emit(new_energy)
			if current_energy == 0:
				no_energy.emit()

func _ready():
	super()
	current_energy = max_energy

func _process(delta):
	if current_energy > 0:
		current_energy -= energy_tick_rate * delta

func decrease_energy(amount: int):
	current_energy -= amount

func increase_energy(amount: int):
	current_energy += amount

# returns true if the consumable was used
func try_apply_consumable(item_id: String) -> bool:
	var effects = Items.get_effects(item_id)
	var consume = false
	
	if effects.has("energy"):
		if current_energy < max_energy:
			increase_energy(effects["energy"])
			consume = true

	if effects.has("health"):
		if current_health < max_health:
			increase_health(effects["health"])
			consume = true
	return consume
