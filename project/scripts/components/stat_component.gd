# A component intended to be attached to an Entity containing and managing
# the statistics of that Entity, like HP.

class_name StatComponent
extends Node

signal health_changed(health: int)
signal no_health(damage_instance: DamageInstance)

@export var max_health: int

var health: int

func _ready() -> void:
	health = max_health

# specifically decreases health by the amount of damage in the DamageInstance
# generally only called by hurt component, to deal damage programmatically, call its hurt method 
func decrease_health(instance: DamageInstance):
	health -= instance.damage
	if instance.damage != 0:
		health_changed.emit(health)
	if health <= 0:
		no_health.emit(instance)

func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	if amount != 0:
		health_changed.emit(health)
