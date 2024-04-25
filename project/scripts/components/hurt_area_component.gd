# Hurt area component, which is an Area2D that emits a signal when it collides 
# with a HitAreaComponent. Reports damage to the controlling hurt component
class_name HurtAreaComponent
extends Area2D

# Emitted when HurtComponent collides with HitAreaComponent
signal collided(damage_instance: DamageInstance)
