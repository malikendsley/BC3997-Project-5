# Main player controller
class_name Player
extends Entity

@onready var equipment_component: EquipmentComponent = %Equipment
@onready var anim_player: AnimationPlayer = %AnimationPlayer

@export_category("References")
@export var game_ui: GameUIController

@export_category("Locomotion")
@export var speed: int = 200 # px/s
@export var acceleration: int = 1500 # px/s^2
@export var deceleration: int = 3000 # px/s^2

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
	# TODO: This seems cyclic, maybe fix _ready() calls?
	game_ui.call_deferred("initialize", stat_component.health, max_energy)
	equipment_component.equipment_finished.connect(regain_control)
	equipment_component.initialize(game_ui)

func _process(delta: float):
	
	# gather input
	input_vector.x = Input.get_axis("move_left", "move_right")
	# godot's positive y is downward
	input_vector.y = Input.get_axis("move_up", "move_down")
	match current_state:
		PlayerState.IDLE:
			move(delta)
			if InputBuffer.consume_action("close_crafting"):
				game_ui.inventory_screen.close_inventory_screen()
			elif InputBuffer.consume_action("open_crafting") and !game_ui.inventory_screen.visible:
				game_ui.inventory_screen.open_inventory_screen()
				current_state = PlayerState.LOCKED

			# play the animation of the highest velocity component
			if input_vector != Vector2.ZERO:
				if abs(input_vector.x) > abs(input_vector.y):
					if input_vector.x > 0:
						anim_player.play("idle_right")
					else:
						anim_player.play("idle_left")
				else:
					if input_vector.y > 0:
						anim_player.play("idle_down")
					else:
						anim_player.play("idle_up")

			if InputBuffer.consume_mouse_down():
				var target = get_global_mouse_position()
				equipment_component.use_equipment(target)
				current_state = PlayerState.ACTION

		PlayerState.LOCKED:
			if InputBuffer.consume_action("close_crafting") or InputBuffer.consume_action("open_crafting") and game_ui.inventory_screen.visible:
				game_ui.inventory_screen.close_inventory_screen()
				current_state = PlayerState.IDLE
		
		PlayerState.ACTION:
			move(delta)

func move(delta: float):
	# move towards input direction with acceleration
	if input_vector != Vector2.ZERO:
		var target_velocity = speed * input_vector.normalized()
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	move_and_slide()

# called when the item is finished being used
func regain_control():
	current_state = PlayerState.IDLE

func handle_hp_change(_new_hp: int):
	game_ui.set_hp(_new_hp)

static func get_singleton() -> Player:
	return (Player as Script).get_meta(&"singleton") as Player
