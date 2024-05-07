extends Node2D

@export var respawn_location: Vector2 = Vector2(0, 0)

@onready var playerref: Player = %Player
@onready var gameuiref: GameUIController = %GameUI
@onready var tilemapref: TileMap = %TileMap
@onready var cityrect: ReferenceRect = %CityArea
@onready var villagerect: ReferenceRect = %VillageArea
@onready var items: Node2D = %Items

@export var num_floor_items_per_biome: int = 30
@export var item_drop_scene: PackedScene
func _input(_event):
    # TODO: Pausing
    pass

func _ready():
    var spawned = 0
    while spawned < num_floor_items_per_biome:
        var x = randf_range(0, cityrect.size.x)
        var y = randf_range(0, cityrect.size.y)
        var item = item_drop_scene.instantiate() as ItemPickup
        item.update_item("stone")
        item.global_position = cityrect.global_position + Vector2(x, y)
        items.call_deferred("add_child", item)
        spawned += 1
    spawned = 0
    while spawned < num_floor_items_per_biome:
        var x = randf_range(0, villagerect.size.x)
        var y = randf_range(0, villagerect.size.y)
        var item = item_drop_scene.instantiate() as ItemPickup
        item.update_item("wood")
        item.global_position = villagerect.global_position + Vector2(x, y)
        items.call_deferred("add_child", item)
        spawned += 1

func _process(_delta):
    pass