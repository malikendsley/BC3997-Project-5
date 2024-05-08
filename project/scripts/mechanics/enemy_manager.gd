extends Node2D

@export var playerref: Player
@onready var cityrect: ReferenceRect = %CityArea
@onready var villagerect: ReferenceRect = %VillageArea

@export var cultist: PackedScene
@export var rabbit: PackedScene
@export var slime: PackedScene
@export var enemies_container: Node2D

var id = 0

# maps string names to references to the enemy types
var enemy_types: Dictionary

var enemy_caps: Dictionary = {
	"cultist": 5,
	"rabbit": 10,
	"slime": 5,
}

var enemy_counts: Dictionary = {
	"cultist": 0,
	"rabbit": 0,
	"slime": 0,
}

var player_biome: String:
	set(new_biome):
		if new_biome != player_biome:
			print("Biome is now", new_biome)
			player_biome = new_biome

func _ready():
	TimeManager.day_to_night.connect(on_day_to_night)
	TimeManager.night_to_day.connect(on_night_to_day)
	update_player_biome()
	enemy_types = {
		"cultist": cultist,
		"rabbit": rabbit,
		"slime": slime,
	}

func _process(_delta):
	update_player_biome()

func on_day_to_night():
	# spawn cultists in the village
	while enemy_counts["cultist"] < enemy_caps["cultist"]:
		var spawn_pos = villagerect.position + Vector2(randf_range(0, villagerect.size.x), randf_range(0, villagerect.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		spawn_enemy("cultist", spawn_pos)
	# spawn slimes in the city
	while enemy_counts["slime"] < enemy_caps["slime"]:
		var spawn_pos = cityrect.position + Vector2(randf_range(0, cityrect.size.x), randf_range(0, cityrect.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		spawn_enemy("slime", spawn_pos)

func on_night_to_day():
	# clear out cultists and slimes
	clear_type_of_enemy("cultist")
	clear_type_of_enemy("slime")
	# replenish rabbits, they can spawn in either biome
	while enemy_counts["rabbit"] < enemy_caps["rabbit"]:
		var city_or_village = cityrect if randf() < 0.5 else villagerect
		var spawn_pos = city_or_village.position + Vector2(randf_range(0, city_or_village.size.x), randf_range(0, city_or_village.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		spawn_enemy("rabbit", spawn_pos)

func update_player_biome():
	if Rect2(cityrect.position, cityrect.size).has_point(playerref.global_position):
		player_biome = "city"
	elif Rect2(villagerect.position, villagerect.size).has_point(playerref.global_position):
		player_biome = "village"

func point_on_screen(point: Vector2):
	return point.x > playerref.global_position.x - 180 and point.x < playerref.global_position.x + 180 and point.y > playerref.global_position.y - 90 and point.y < playerref.global_position.y + 90

func clear_type_of_enemy(type: String):
	for enemy in enemies_container.get_children():
		if (enemy as Enemy).enemy_id == type:
			enemy.queue_free()
			enemy_counts[type] -= 1

func spawn_enemy(enemy_type: String, pos: Vector2):
	var enemy_instance = enemy_types[enemy_type].instantiate()
	enemy_instance.name = enemy_type + str(id)
	id += 1
	enemy_instance.global_position = pos
	enemy_instance.killed.connect(handle_enemy_killed)
	enemies_container.add_child(enemy_instance)
	enemy_counts[enemy_type] += 1

func handle_enemy_killed(enemy: Enemy):
	enemy_counts[enemy.enemy_id] -= 1