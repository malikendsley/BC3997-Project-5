# Hurt area component, which is an Area2D that emits a signal when it collides 
# with a HitAreaComponent. Hooks into the general damage system.

class_name HurtAreaComponent
extends Area2D

# Emitted when HurtAreaComponent collides with HitAreaComponent
signal collided(damage_instance: DamageInstance)

@export var invulnerable_duration: float = 0.2
var invulnerable_duration_timer: Timer = Timer.new()

var is_invulnerable: bool = false:
	set(value):
		is_invulnerable = value
		invulnerable_duration_timer.start(invulnerable_duration)
		get_child(0).set_deferred("disabled", is_invulnerable) # Child should be CollisionShape

func _ready() -> void:
	add_child(invulnerable_duration_timer)
	invulnerable_duration_timer.one_shot = true
	invulnerable_duration_timer.timeout.connect(handle_invulnerability_timeout)

func handle_invulnerability_timeout() -> void:
	is_invulnerable = false