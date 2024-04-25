class_name HitAreaComponent
extends Area2D

signal hit_something(damage_instance: DamageInstance, target: Node2D)

## If true, the hit area will continuously damage the target each frame it is in the area.
@export var continuous: bool = false
@export var damage: int = 1
@export var damage_faction: DamageInstance.Faction = DamageInstance.Faction.HOSTILE

var damage_targets = []

func _ready():
    area_entered.connect(_on_hurt_area_entered)
    area_exited.connect(_on_hurt_area_exited)

func _process(_delta):
    if continuous:
        for target in damage_targets:
            _damage_target(target)

func _on_hurt_area_entered(hurt_area: HurtComponent):
    print("Area entered")
    if hurt_area is HurtComponent:
        print("Area is hurt area")
        if continuous:
            if hurt_area not in damage_targets:
                damage_targets.append(hurt_area)
        else:
            _damage_target(hurt_area)

func _on_hurt_area_exited(hurt_area: HurtComponent):
    if hurt_area is HurtComponent and hurt_area in damage_targets:
        damage_targets.erase(hurt_area)

func _damage_target(target: HurtComponent):
    var damage_instance = DamageInstance.new(damage, damage_faction, self, position)
    hit_something.emit(damage_instance, target)
    target.check_hit(damage_instance)