extends Node

var time_passed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if(time_passed > 1.0):
		print(Items.items)
		print(Items.player_items)
		time_passed = 0.0
	Items.add_item("wood")
	pass
