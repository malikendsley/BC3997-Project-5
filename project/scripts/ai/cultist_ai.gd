class_name CultistAI
extends AggressiveAI

# Normal agressive AI with animation controls for the cultist enemy
@onready var actual_sprite: AnimatedSprite2D = %ActualSprite

var last_postion := Vector2()
var displacement := Vector2()
var last_facing_x: float

func _process(delta):
    super(delta)
    displacement = global_position - last_postion
    last_postion = global_position

    if displacement.length() > 1:
        last_facing_x = displacement.x
        body_sprite.scale = Vector2(last_facing_x, 1)
    else:
        body_sprite.scale = Vector2( - 1 if playerref.global_position.x < global_position.x else 1, 1)
    # The attack module will take over animation during the attack
    if cur_state != EnemyState.ATTACKED and cur_state != EnemyState.DEAD:
        if displacement.length() == 0:
            actual_sprite.play("idle")
        else:
            actual_sprite.play("move")

func handle_destroyed(d_i):
    velocity = Vector2()
    cur_state = EnemyState.DEAD # Prevents the AI from doing anything else
    print("killed")
    actual_sprite.play("die")
    await get_tree().create_timer(0.5).timeout
    super(d_i)