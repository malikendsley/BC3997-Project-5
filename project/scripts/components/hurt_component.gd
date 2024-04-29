# Top level damage receiver component. Can be damaged by opposing hitboxes if
# they hit hurt areas (which will report the damage to this component).
class_name HurtComponent
extends Area2D

signal damaged(damage_instance: DamageInstance)

@export var stat_component: StatComponent
# TODO: If we want composite hitboxes at any point, make this a list

@export var faction: DamageInstance.Faction # what faction this hurtbox is in
@export var invulnerable_duration: float = 0.2
var invulnerable_duration_timer: Timer = Timer.new()

var is_invulnerable: bool = false:
	set(value):
		is_invulnerable = value
		invulnerable_duration_timer.start(invulnerable_duration)

func _ready():
	add_child(invulnerable_duration_timer)
	invulnerable_duration_timer.one_shot = true
	invulnerable_duration_timer.timeout.connect(handle_invulnerability_timeout)

func send_damage(damage_instance: DamageInstance):
	if is_invulnerable:
		return
	if damage_instance.faction != faction:
		stat_component.decrease_health(damage_instance)
		damaged.emit(damage_instance)

func handle_invulnerability_timeout() -> void:
	is_invulnerable = false
