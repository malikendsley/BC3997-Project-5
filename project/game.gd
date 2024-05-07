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

var num_wood = 0
var num_stone = 0

func _ready():
    playerref.global_position = respawn_location
    spawn_items()
    # refresh the floor loot every night
    TimeManager.night_to_day.connect(spawn_items)

func spawn_items():
    while num_stone < num_floor_items_per_biome:
        var x = randf_range(0, cityrect.size.x)
        var y = randf_range(0, cityrect.size.y)
        var item = item_drop_scene.instantiate() as ItemPickup
        item.collected.connect(on_item_collected)
        item.update_item("stone")
        item.global_position = cityrect.global_position + Vector2(x, y)
        items.call_deferred("add_child", item)
        num_stone += 1
    while num_wood < num_floor_items_per_biome:
        var x = randf_range(0, villagerect.size.x)
        var y = randf_range(0, villagerect.size.y)
        var item = item_drop_scene.instantiate() as ItemPickup
        item.collected.connect(on_item_collected)
        item.update_item("wood")
        item.global_position = villagerect.global_position + Vector2(x, y)
        items.call_deferred("add_child", item)
        num_wood += 1

func on_item_collected(id: String):
    if id == "wood":
        num_wood -= 1
    elif id == "stone":
        num_stone -= 1