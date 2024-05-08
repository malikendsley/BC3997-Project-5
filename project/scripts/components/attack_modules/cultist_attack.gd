class_name CultistAttack
extends AttackModule

# a hack for actual sprite is used here to fix alignment issues.
# TODO: Re-align sprite so we can remove this hack
@export var bullet_scene: PackedScene
@export var spawn_anchor: Node2D
@onready var shoot_sound: AudioStreamPlayer = %ShootSound

# fire a burst of 3 shots at the target
func attack(target: Player):
	for i in range(3):
		# the attack was interrupted
		if attached_ai.cur_state != attached_ai.EnemyState.ATTACKED:
			return
		attached_ai.actual_sprite.play("shoot")
		shoot_sound.play()
		var bullet = bullet_scene.instantiate()
		bullet.global_position = spawn_anchor.global_position
		get_tree().current_scene.add_child(bullet)
		bullet.fire(target.global_position - spawn_anchor.global_position)
		await attached_ai.actual_sprite.animation_finished
	attack_finished.emit()
