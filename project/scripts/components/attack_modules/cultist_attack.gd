class_name CultistAttack
extends AttackModule

# a hack for actual sprite is used here to fix alignment issues.
# TODO: Re-align sprite so we can remove this hack
@export var bullet_scene: PackedScene
@export var spawn_anchor: Node2D

# fire a burst of 3 shots at the target
func attack(target: Player):

	for i in range(3):
		# the attack was interrupted
		if attached_ai.cur_state != attached_ai.EnemyState.ATTACKED:
			return
		attached_ai.actual_sprite.play("shoot")
		await attached_ai.actual_sprite.animation_finished
	attack_finished.emit()
