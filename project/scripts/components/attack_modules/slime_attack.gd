class_name SlimeAttack
extends AttackModule

@export var lunge_distance = 20

func attack(target: Player):
    print("Attacking")
    # basically add an impulse in the direction of the player, and accelerate towards 0 at the same time
    var player_pos = target.global_position
    var final_destination = player_pos + (player_pos - global_position).normalized() * lunge_distance
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).tween_property(attached_ai, "global_position", final_destination, .75)
    tween.tween_callback(finish)

func finish():
    print("Returning control")
    attack_finished.emit()