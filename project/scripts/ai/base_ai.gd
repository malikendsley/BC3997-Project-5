class_name Enemy
extends Entity

@onready var aggro_area: CollisionShape2D = %AggroCircle
@onready var deaggro_area: CollisionShape2D = %DeaggroCircle
@export var move_speed: float = 100

@export var enemy_id: String
@export var aggro_range: float = 300
@export var deaggro_range: float = 500

#TODO: Move these into the DamageInstance
@export var knockback_distance: float = 20
@export var knockback_time: float = 0.33
@export var attack_module: AttackModule

enum EnemyState {
	IDLE, # not aggro
	AGGRO, # aggro
	ATTACKED, # just attacked, waiting for attack module to return control
	WAITING, # waiting for attack timer to expire
	HITSTUN,
	DEAD,
}

var cur_state: EnemyState = EnemyState.IDLE
var playerref: Player

# on spawn, generate the loot this enemy is carrying (which will drop on death)
func _ready():
	super()
	var loot_id = Items.roll_loot_table(enemy_id)
	if loot_id != "":
		var num_items = randi() % 3 + 1
		inventory.add_item(loot_id, num_items)
	assert(aggro_area.shape is CircleShape2D)
	assert(deaggro_area.shape is CircleShape2D)
	aggro_area.shape.radius = aggro_range
	deaggro_area.shape.radius = deaggro_range
	playerref = Player.get_singleton()
	if attack_module:
		attack_module.attached_ai = self

func handle_destroyed(_d_i: DamageInstance) -> void:
	super(_d_i)
	inventory.drop_inventory_on_ground()
	queue_free()

func handle_hit(d_i: DamageInstance) -> void:
	super(d_i)
	if cur_state == EnemyState.DEAD:
		return
	# apply hitstun
	cur_state = EnemyState.HITSTUN
	# move the enemy away from the player
	var final_destination = global_position + (global_position - playerref.global_position).normalized() * knockback_distance
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).tween_property(self, "global_position", final_destination, knockback_time)
	tween.tween_callback(func(): cur_state=EnemyState.AGGRO)

func is_player_in_range() -> bool:
	return player_in_range

var player_in_range: bool = false
func _on_aggro_range_enter(body: Node) -> void:
	if body is Player:
		player_in_range = true

func _on_deaggro_range_exit(body: Node) -> void:
	if body is Player:
		player_in_range = false
