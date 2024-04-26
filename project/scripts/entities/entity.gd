# Base class for most (if not all) moving objects.

class_name Entity
extends CharacterBody2D

#region Entity Components
@onready var stat_component: StatComponent = %StatComponent
@onready var hurt_component: HurtComponent = %HurtComponent
@onready var hurt_area_component: HurtComponent = %HurtComponent
@onready var body_sprite: AnimatedSprite2D = %BodySprite
@onready var sfx_player: AnimationPlayer = %SFXPlayer
#endregion

func _ready() -> void:
    add_to_group("entity")
    # Connect to component signals here
    stat_component.no_health.connect(handle_destroyed)
    hurt_component.damaged.connect(handle_hit)

# hit, deflect and destroyed behavior common to every entity
func handle_hit(_d_i: DamageInstance) -> void:
    print("Entity: ", name, " hit")
    sfx_player.play("flash")
    hurt_area_component.is_invulnerable = true

func handle_deflect() -> void:
    pass

func handle_destroyed(_d_i: DamageInstance) -> void:
    pass
