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
var last_anim = ""

func _ready():
	super()
	get_script().set_meta(&"singleton", self) # set as singleton
	add_to_group("player") # in case needed
	stat_component.health_changed.connect(_handle_hp_change)
	# TODO: This seems cyclic, maybe fix _ready() calls?
	game_ui.call_deferred("initialize", stat_component.health, max_energy)
	game_ui.item_equipped.connect(_handle_item_equipped)
	game_ui.item_consumed.connect(_handle_item_consumed)
	equipment_component.equipment_finished.connect(regain_control)
	equipment_component.initialize(game_ui)

func _process(delta: float):
	
	# gather input
	input_vector.x = Input.get_axis("move_left", "move_right")
	# godot's positive y is downward
	input_vector.y = Input.get_axis("move_up", "move_down")
	match current_state:
		PlayerState.IDLE:
			_move(delta)
			if InputBuffer.consume_action("close_crafting"):
				game_ui.inventory_screen.close_inventory_screen()
			elif InputBuffer.consume_action("open_crafting") and !game_ui.inventory_screen.visible:
				game_ui.inventory_screen.open_inventory_screen()
				current_state = PlayerState.LOCKED

			# play the animation of the highest velocity component
			if input_vector != Vector2.ZERO:
				if abs(input_vector.x) > abs(input_vector.y):
					if input_vector.x > 0:
						_play_animation("idle_right")
					else:
						_play_animation("idle_left")
				else:
					if input_vector.y > 0:
						_play_animation("idle_down")
					else:
						_play_animation("idle_up")

			if InputBuffer.consume_mouse_down():
				var target = get_global_mouse_position()
				equipment_component.use_equipment(target)
				current_state = PlayerState.ACTION

		PlayerState.LOCKED:
			if InputBuffer.consume_action("close_crafting") or InputBuffer.consume_action("open_crafting") and game_ui.inventory_screen.visible:
				game_ui.inventory_screen.close_inventory_screen()
				current_state = PlayerState.IDLE
		
		PlayerState.ACTION:
			_move(delta)

func _move(delta: float):
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
	# since only movement animations are stored, this will restore the animation playing just prior 
	# to the action
	anim_player.play(last_anim)

func _play_animation(anim_name: String):
	anim_player.play(anim_name)
	last_anim = anim_name # store the last animation played

func _handle_item_consumed(_item_id: String):
	pass

func _handle_item_equipped(item_id: String):
	equipment_component.equip_item(item_id)

func _handle_hp_change(_new_hp: int):
	game_ui.set_hp(_new_hp)

static func get_singleton() -> Player:
	return (Player as Script).get_meta(&"singleton") as Player
