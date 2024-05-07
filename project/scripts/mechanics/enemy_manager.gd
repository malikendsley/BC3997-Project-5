extends Node2D

@export var playerref: Player
@onready var cityrect: ReferenceRect = %CityArea
@onready var villagerect: ReferenceRect = %VillageArea

@export var cultist: PackedScene
@export var rabbit: PackedScene
@export var slime: PackedScene
@export var enemies_container: Node2D

var enemycaps: Dictionary = {
	"cultist": 5,
	"rabbit": 10,
	"slime": 5,
}

var enemycounts: Dictionary = {
	"cultist": 0,
	"rabbit": 0,
	"slime": 0,
}

var enemies: Array = []

var player_biome: String:
	set(new_biome):
		if new_biome != player_biome:
			print("Biome is now", new_biome)
			player_biome = new_biome

func _ready():
	TimeManager.day_to_night.connect(on_day_to_night)
	TimeManager.night_to_day.connect(on_night_to_day)
	update_player_biome()

func _process(_delta):
	update_player_biome()

func on_day_to_night():
	# spawn cultists in the village
	while enemycounts["cultist"] < enemycaps["cultist"]:
		var spawn_pos = villagerect.position + Vector2(randf_range(0, villagerect.size.x), randf_range(0, villagerect.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		var cultist_instance = cultist.instantiate()
		cultist_instance.global_position = spawn_pos
		enemies_container.add_child(cultist_instance)
		enemies.append(cultist_instance)
		enemycounts["cultist"] += 1
	# spawn slimes in the city
	while enemycounts["slime"] < enemycaps["slime"]:
		var spawn_pos = cityrect.position + Vector2(randf_range(0, cityrect.size.x), randf_range(0, cityrect.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		var slime_instance = slime.instantiate()
		slime_instance.global_position = spawn_pos
		enemies_container.add_child(slime_instance)
		enemies.append(slime_instance)
		enemycounts["slime"] += 1

func on_night_to_day():
	# clear out cultists and slimes
	clear_type_of_enemy("cultist")
	clear_type_of_enemy("slime")
	# replenish rabbits, they can spawn in either biome
	while enemycounts["rabbit"] < enemycaps["rabbit"]:
		var city_or_village = cityrect if randf() < 0.5 else villagerect
		print("Spawning rabbit in " + city_or_village.name)
		var spawn_pos = city_or_village.position + Vector2(randf_range(0, city_or_village.size.x), randf_range(0, city_or_village.size.y))
		# don't spawn on screen of the player. the bounds of the screen are playerref.$Camera2D's position +- 180x and 90y
		if point_on_screen(spawn_pos):
			continue
		var rabbit_instance = rabbit.instantiate()
		rabbit_instance.global_position = spawn_pos
		enemies_container.add_child(rabbit_instance)
		enemies.append(rabbit_instance)
		enemycounts["rabbit"] += 1

func update_player_biome():
	if Rect2(cityrect.position, cityrect.size).has_point(playerref.global_position):
		player_biome = "city"
	elif Rect2(villagerect.position, villagerect.size).has_point(playerref.global_position):
		player_biome = "village"

func point_on_screen(point: Vector2):
	return point.x > playerref.global_position.x - 180 and point.x < playerref.global_position.x + 180 and point.y > playerref.global_position.y - 90 and point.y < playerref.global_position.y + 90

func clear_type_of_enemy(type: String):
	for enemy in enemies:
		print("Checking ", enemy)
		if enemy == type:
			# TODO: Replace with more of a vanish effect (as if they leave the area)
			enemy.queue_free()
			enemies.erase(enemy)
