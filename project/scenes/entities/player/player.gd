# Main player controller
class_name Player
extends Entity

const ending_scene = "res://project/scenes/ui/ending/endingscene.tscn"

@onready var equipment_component: EquipmentComponent = %Equipment
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var fullscreen_color_rect: ColorRect = %ColorRect
@onready var marina_popup: Panel = %MarinaPopup
@onready var cam: Camera2D = %Camera2D
@export_category("References")
@export var game_ui: GameUIController
@export var marina_boat: Sprite2D

@export_category("Locomotion")
@export var speed: int = 200 # px/s
@export var acceleration: int = 1500 # px/s^2
@export var deceleration: int = 3000 # px/s^2

# subject to change
enum PlayerState {
	IDLE, # not doing anything
	BUSY, # inputs BUSY out (menu, for example)
	ACTION, # executing some action like attacking
	LOCKED # player is dead or something
}

var current_state: PlayerState = PlayerState.IDLE
var input_vector = Vector2()
var last_anim = ""
var start_pos: Vector2
var in_marina: bool = false

func _ready():
	super()
	get_script().set_meta(&"singleton", self) # set as singleton
	add_to_group("player") # in case needed
	stat_component.health_changed.connect(_handle_hp_change)
	stat_component.energy_changed.connect(_handle_energy_change)
	stat_component.no_health.connect(_handle_killed)
	# TODO hacky but works because we don't care about the damage instance
	(stat_component as PlayerStatComponent).no_energy.connect(_handle_killed.bind(DamageInstance.new(0, DamageInstance.Faction.NONE, self, Vector2())))
	# TODO: This seems cyclic, maybe fix _ready() calls?
	game_ui.call_deferred("initialize", stat_component.current_health, stat_component.max_energy, self)
	game_ui.item_equipped.connect(_handle_item_equipped)
	game_ui.item_consumed.connect(_handle_item_consumed)
	equipment_component.equipment_finished.connect(regain_control)
	equipment_component.initialize(game_ui)
	marina_popup.visible = false

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
				current_state = PlayerState.BUSY

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

		PlayerState.BUSY:
			if InputBuffer.consume_action("close_crafting") or InputBuffer.consume_action("open_crafting") and game_ui.inventory_screen.visible:
				game_ui.inventory_screen.close_inventory_screen()
				current_state = PlayerState.IDLE
		
		PlayerState.ACTION:
			_move(delta)

		PlayerState.LOCKED:
			pass

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

func _handle_item_consumed(item_id: String):
	if (stat_component as PlayerStatComponent).try_apply_consumable(item_id):
		SoundManager.play_sound("eat")
		inventory.remove_item(item_id)

func _handle_item_equipped(item_id: String):
	SoundManager.play_sound("equip")
	equipment_component.equip_item(item_id)

func _handle_hp_change(new_hp: int):
	game_ui.set_hp(new_hp)

func _handle_killed(_d_i: DamageInstance):
	game_ui.set_hp(0)
	game_ui.inventory_screen.close_inventory_screen()
	current_state = PlayerState.LOCKED
	for i in range(3):
		sfx_player.play("flash")
		await sfx_player.animation_finished
		await get_tree().create_timer(0.25).timeout
	body_sprite.visible = false
	equipment_component.equip_item("")
	inventory.drop_inventory_on_ground()
	await get_tree().create_timer(1).timeout
	# TODO: If we decide to have a game over screen, this is where it would be called
	var tween = get_tree().create_tween()
	tween.tween_property(fullscreen_color_rect, "color", Color(0, 0, 0, 1), 1)
	await tween.finished
	global_position = start_pos
	tween = get_tree().create_tween()
	tween.tween_property(fullscreen_color_rect, "color", Color(0, 0, 0, 0), 1)
	await tween.finished
	body_sprite.visible = true
	stat_component.current_health = stat_component.max_health
	(stat_component as PlayerStatComponent).current_energy = (stat_component as PlayerStatComponent).max_energy
	current_state = PlayerState.IDLE

func _handle_energy_change(new_energy: int):
	game_ui.set_energy(new_energy)

static func get_singleton() -> Player:
	return (Player as Script).get_meta(&"singleton") as Player

func marina_enter(body: Node2D):
	print("enter")
	if body is Player:
		in_marina = true
		marina_popup.visible = true

func marina_exit(body: Node2D):
	if body is Player:
		in_marina = false
		marina_popup.visible = false

func on_end_game():
	game_ui.visible = false
	marina_popup.visible = false
	marina_boat.visible = true
	current_state = PlayerState.LOCKED
	cam.position_smoothing_enabled = false
	game_ui.inventory_screen.close_inventory_screen()
	await get_tree().create_timer(1).timeout
	var cam_old_pos = cam.global_position
	cam.reparent(get_parent())
	cam.global_position = cam_old_pos # just in case
	reparent(marina_boat)
	# set local position to 0
	position = Vector2()
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property(marina_boat, "position", marina_boat.global_position + Vector2( - 200, 0), 2)
	await get_tree().create_timer(2).timeout
	get_tree().create_tween().tween_property(fullscreen_color_rect, "color", Color(0, 0, 0, 1), 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(ending_scene)
