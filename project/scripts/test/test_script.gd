extends Node

var inventory_screen_scene = preload("res://project/scenes/ui/inventory/inventory_ui.tscn")
var time_passed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if(time_passed > 1.0):
		print(Inventory.items)
		time_passed = 0.0
	Inventory.add_item("wood")
	
	if Input.is_action_pressed("open_crafting"):
		inventory_screen()
	

func inventory_screen():
	var inventory_screen_instance = inventory_screen_scene.instantiate()
	get_tree().get_root().add_child(inventory_screen_instance)
