class_name AggressiveAI
extends Enemy

@export var attack_range: float = 50
@export var attack_time: float = 0.5
@export var cooldown_time: float = 0.5

@onready var attack_timer: float = attack_time
@onready var cooldown_timer: float = cooldown_time

func _ready():
	super()
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
					# scale the move vector slightly down when nearing ideal range
					velocity = (playerref.global_position - global_position).normalized() * move_speed
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

func handle_attack_finished():
	cooldown_timer = cooldown_time
	cur_state = EnemyState.WAITING
