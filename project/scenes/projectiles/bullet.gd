extends CharacterBody2D

var fired = false
@export var speed = 90
@export var lifetime = 1.5
var timer = 0.0

func fire(dir: Vector2):
    # translate continuously towards the direction
    velocity = dir.normalized() * speed
    fired = true
    timer = lifetime

func _process(_delta):
    if fired:
        move_and_slide()
        timer -= _delta
        if timer <= 0:
            queue_free()

func _on_hit_area_component_hit_something(_damage_instance, _target):
    queue_free()