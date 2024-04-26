extends Node

@export var items: Dictionary = {}

func _ready():
	load_items()

func load_items():
	var file = FileAccess.open("res://project/data/items.json", FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	items = data["items"]
	file.close()
