extends Control

var item_button:BaseButton = null

func _ready():
	item_button = get_node("ItemButton")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_button_pressed():
	print("Button pressed")
