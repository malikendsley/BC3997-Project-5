# A component intended to be attached to an Entity containing and managing
# the statistics of that Entity, like HP.

class_name StatComponent
extends Node

signal health_changed(health: int)
signal no_health(damage_instance: DamageInstance)

@export var max_health: int
var current_health: int:
	set(new_health):
		if new_health != current_health:
			current_health = clamp(new_health, 0, max_health)
			health_changed.emit(current_health)

func _ready():
	current_health = max_health

# specifically decreases current_health by the amount of damage in the DamageInstance
# generally only called by hurt component, to deal damage programmatically, call its hurt method 
func decrease_health(instance: DamageInstance):
	current_health -= instance.damage
	if current_health == 0:
		no_health.emit(instance)

func increase_health(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	if amount != 0 and current_health != max_health:
		health_changed.emit(current_health)
