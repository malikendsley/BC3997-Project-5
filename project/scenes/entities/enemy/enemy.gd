class_name Enemy
extends Entity

@onready var aggro_area: CollisionShape2D = %AggroCircle
@onready var deaggro_area: CollisionShape2D = %DeaggroCircle

@export var enemy_id: String = "slime"
@export var aggro_range: float = 300
@export var deaggro_range: float = 500

@export var attack_range: float = 50
@export var move_speed: float = 100
@export var attack_time: float = 0.5
@export var cooldown_time: float = 0.5

@export var attack_module: AttackModule
@onready var attack_timer: float = attack_time
@onready var cooldown_timer: float = cooldown_time
enum EnemyState {
    IDLE, # not aggro
    AGGRO, # aggro
    ATTACKED, # just attacked, waiting for attack module to return control
    WAITING, # waiting for attack timer to expire
}

var state_names = {
    EnemyState.IDLE: "IDLE",
    EnemyState.AGGRO: "AGGRO",
    EnemyState.ATTACKED: "ATTACKED",
    EnemyState.WAITING: "WAITING",
}
var cur_state: EnemyState = EnemyState.IDLE:
    set(new_state):
        if new_state != cur_state:
            print("State change: ", state_names[cur_state], " -> ", state_names[new_state])
        cur_state = new_state
var playerref: Player

# on spawn, generate the loot this enemy is carrying (which will drop on death)
func _ready():
    super()
    var loot_id = Items.roll_loot_table(enemy_id)
    if loot_id != "":
        print("Adding loot")
        inventory.add_item(loot_id, randi() % 3 + 1)
    assert(aggro_area.shape is CircleShape2D)
    assert(deaggro_area.shape is CircleShape2D)
    aggro_area.shape.radius = aggro_range
    deaggro_area.shape.radius = deaggro_range
    playerref = Player.get_singleton()
    attack_module.attached_ai = self
    attack_module.attack_finished.connect(handle_attack_finished)

func _process(delta):
    match cur_state:
        EnemyState.IDLE:
            if is_player_in_range():
                cur_state = EnemyState.AGGRO
        EnemyState.AGGRO:
            if not is_player_in_range():
                cur_state = EnemyState.IDLE
            else:
                # if outside of attack range, move towards player and reset attack timer
                if playerref.global_position.distance_to(global_position) > attack_range:
                    var move_vector = (playerref.global_position - global_position).normalized() * move_speed
                    # scale the move vector slightly down when nearing ideal range
                    move_vector = move_vector * (playerref.global_position.distance_to(global_position) / attack_range)
                    velocity = move_vector
                    attack_timer = attack_time
                    move_and_slide()
                else:
                    # start ticking the attack timer
                    attack_timer -= delta
                    if attack_timer <= 0:
                        velocity = Vector2.ZERO # give atk module a clean slate
                        cur_state = EnemyState.ATTACKED
                        attack_module.attack(playerref)
                        attack_timer = 0
        EnemyState.ATTACKED:
            # wait for attack module to return control
            pass
        EnemyState.WAITING:
            cooldown_timer -= delta
            if cooldown_timer <= 0:
                cur_state = EnemyState.AGGRO
                cooldown_timer = 0 # not necessary but good housekeeping

func handle_destroyed(_d_i: DamageInstance) -> void:
    super(_d_i)
    inventory.drop_inventory_on_ground()
    queue_free()

func handle_attack_finished():
    cooldown_timer = cooldown_time
    cur_state = EnemyState.WAITING

func is_player_in_range() -> bool:
    return player_in_range

var player_in_range: bool = false
func _on_aggro_range_enter(body: Node) -> void:
    if body is Player:
        print("Player in range")
        player_in_range = true

func _on_deaggro_range_exit(body: Node) -> void:
    if body is Player:
        print("Player out of range")
        player_in_range = false
