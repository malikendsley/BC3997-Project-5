# Main player controller
class_name Player
extends Entity

@export_category("References")
@export var game_ui: GameUIController

@export_category("Locomotion")
@export var speed: int = 50 # px/s
@export var acceleration: int = 300 # px/s^2

# TODO: Move into stat component?
@export_category("Stats")
@export var max_energy: int = 100
var current_energy: int = 100

# subject to change
enum PlayerState {
	IDLE, # not doing anything
	LOCKED, # inputs locked out (menu, for example)
	ACTION, # executing some action like attacking
}

var current_state: PlayerState = PlayerState.IDLE
var input_vector = Vector2()

func _ready():
	super()
	get_script().set_meta(&"singleton", self) # set as singleton
	add_to_group("player") # in case needed
	stat_component.health_changed.connect(handle_hp_change)
    # initialize UI, defer becuase UI isn't ready yet
	game_ui.call_deferred("initialize", stat_component.health, max_energy)

func _process(delta: float):
	
	# gather input
	input_vector.x = Input.get_axis("move_left", "move_right")
	# godot's positive y is downward
	input_vector.y = Input.get_axis("move_up", "move_down")

	match current_state:
		PlayerState.IDLE:
			move(delta)
		PlayerState.LOCKED:
			pass
		PlayerState.ACTION:
			pass
	
	pass

func move(delta: float):
	# move towards input direction with acceleration
	var target_velocity = input_vector * speed
	var velocity_change_vector = target_velocity - velocity
	velocity_change_vector = velocity_change_vector.limit_length(acceleration * delta)
	velocity += velocity_change_vector
	# prevent velocity from going over target
	velocity = velocity.limit_length(speed)
	move_and_slide()

func handle_hp_change(_new_hp: int):
	game_ui.set_hp(_new_hp)

static func get_singleton() -> Player:
	return (Player as Script).get_meta(&"singleton") as Player
