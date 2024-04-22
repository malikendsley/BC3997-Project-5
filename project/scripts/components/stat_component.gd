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