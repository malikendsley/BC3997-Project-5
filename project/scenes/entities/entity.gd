# Base class for most (if not all) moving objects.

class_name Entity
extends CharacterBody2D

#region Entity Components
@onready var stat_component: StatComponent = %StatComponent
@onready var hurt_component: HurtComponent = %HurtComponent
@onready var hurt_area_component: HurtComponent = %HurtComponent
@onready var body_sprite: AnimatedSprite2D = %BodySprite
@onready var sfx_player: AnimationPlayer = %SFXPlayer
@onready var inventory: Inventory = %Inventory
@onready var hitsoundplayer: AudioStreamPlayer = %HitSoundPlayer
#endregion

func _ready() -> void:
	add_to_group("entities")
	# Connect to component signals here
	stat_component.no_health.connect(handle_destroyed)
	hurt_component.damaged.connect(handle_hit)

# hit, deflect and destroyed behavior common to every entity
func handle_hit(_d_i: DamageInstance) -> void:
	sfx_player.play("flash")
	hurt_area_component.is_invulnerable = true
	hitsoundplayer.play()
func handle_deflect() -> void:
	pass

func handle_destroyed(_d_i: DamageInstance) -> void:
	SoundManager.play_sound("death")