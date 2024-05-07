extends Node2D

@export var playerref: Player
@onready var cityrect: ReferenceRect = %CityArea
@onready var villagerect: ReferenceRect = %VillageArea

const viewport: Vector2 = Vector2(320, 180)

var enemies: Array = []

var player_biome: String

func _ready():
	TimeManager.day_to_night.connect(on_day_to_night)
	TimeManager.night_to_day.connect(on_night_to_day)
	update_player_biome()

func _process(_delta):
	update_player_biome()

func on_day_to_night():
	pass

func on_night_to_day():
	pass

func update_player_biome():
	if Rect2(cityrect.position, cityrect.size).has_point(playerref.global_position):
		player_biome = "city"
	elif Rect2(villagerect.position, villagerect.size).has_point(playerref.global_position):
		player_biome = "village"
