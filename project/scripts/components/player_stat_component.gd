# Specific stat component for the player

class_name PlayerStatComponent
extends StatComponent

signal energy_changed(new_energy: int)
signal no_energy()

@export var max_energy: int = 100
var current_energy: int:
	set(new_energy):
		if current_energy != new_energy:
			current_energy = clamp(new_energy, 0, max_energy)
			energy_changed.emit(new_energy)
			if current_energy == 0:
				emit_signal("no_energy")

func _ready():
	super()
	current_energy = max_energy

func decrease_energy(amount: int):
	current_energy -= amount

func increase_energy(amount: int):
	current_energy += amount

# returns true if the consumable was used
func try_apply_consumable(item_id: String) -> bool:
	var effects = Items.get_effects(item_id)
	print(effects)
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
