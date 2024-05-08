class_name PassiveAI
extends Enemy

var wander_timer := 0.0
@export var wander_time := 2.0
@export var wander_distance := 100.0
var destination = Vector2()
# movement change since the last frame
var displacement = Vector2()
var lastpos = Vector2()
@onready var flee_speed = move_speed * 1.5

func _process(delta):
    handle_anim()
    displacement = global_position - lastpos
    lastpos = global_position
    match cur_state:
        EnemyState.IDLE:
            wander_timer -= delta
            if wander_timer <= 0:
                wander_timer = wander_time
                var angle = randf() * 2 * PI
                destination = Vector2(global_position.x + cos(angle) * wander_distance, global_position.y + sin(angle) * wander_distance)
            move_to_point(destination)
            if player_in_range:
                cur_state = EnemyState.AGGRO
        EnemyState.AGGRO:
            # flee from player
            destination = global_position # when we return to idle, will stop in place
            var dir = (global_position - playerref.global_position).normalized()
            velocity = dir * flee_speed
            move_and_slide()

            if !player_in_range:
                cur_state = EnemyState.IDLE

# moves towards target point, stopping if it is close
func move_to_point(target):
    if global_position.distance_to(target) < 2:
        velocity = Vector2()
        return
    velocity = (target - global_position).normalized() * move_speed
    move_and_slide()

func handle_anim():
    if displacement.length() < 1:
        # pick the idle animation based on the longest axis of the last displacement
        if abs(displacement.x) > abs(displacement.y):
            body_sprite.play("idle_left" if displacement.x < 0 else "idle_right")
        else:
            body_sprite.play("idle_up" if displacement.y < 0 else "idle_down")

    else:
        # pick the walk animation based on the longest axis of the last displacement
        if abs(displacement.x) > abs(displacement.y):
            body_sprite.play("move_left" if displacement.x < 0 else "move_right")
        else:
            body_sprite.play("move_up" if displacement.y < 0 else "move_down")