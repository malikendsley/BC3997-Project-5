extends Node

func _process(_delta:float):
	if Input.is_action_pressed("close_crafting"):
		close_inventory_screen()
		
func close_inventory_screen():
	queue_free()
