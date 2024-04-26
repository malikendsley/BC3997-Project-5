extends Node

var time_since_change : float = 0
const BUTTON_DELAY: float = 0.5

func _ready():
	self.visible = false

func _process(delta:float):
	time_since_change += delta
	
	if Input.is_action_pressed("close_crafting"):
		time_since_change = BUTTON_DELAY + 0.1
		close_inventory_screen()
	else:
		if (time_since_change <= BUTTON_DELAY):
			return
		if Input.is_action_pressed("open_crafting"):
			if self.visible:
				time_since_change = 0.0
				close_inventory_screen()
			else:
				time_since_change = 0.0
				open_inventory_screen()
		
func close_inventory_screen():
	self.visible = false
	
func open_inventory_screen():
	self.visible = true

