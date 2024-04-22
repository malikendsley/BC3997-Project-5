class_name HurtComponent
extends Node

signal damaged(damage_instance: DamageInstance)

@export var stat_component: StatComponent
# @export var hurt_area_component : HurtAreaComponent

@export var faction: DamageInstance.Faction # what faction this hurtbox is in

# other stuff here