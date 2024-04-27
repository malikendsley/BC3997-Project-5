extends CharacterBody2D

const texture_template = "res://project/textures/items/%s.png"

@export var item_id: String = "wood"
@export var quantity: int = 1

var item_texture: Sprite2D = null
var player_inventory_node = null

const BOUNCE_AMPLITUDE = 10
const TIME_MULTIPLIER = 10
var curr_time: float = 0.0

func _ready():
	if !Items.is_item(item_id):
		print("item_pickup: Invalid item ", item_id)
		return
		
	if quantity < 1:
		print("item_pickup: Invalid quantity ", quantity)
		return

	item_texture = get_node("Sprites/Sprite2D")
	item_texture.texture = load(texture_template % item_id)
	player_inventory_node = Player.get_singleton().inventory

func _physics_process(delta):
	# Bounce up and down.
	curr_time += delta
	velocity.y = sin(curr_time * TIME_MULTIPLIER) * BOUNCE_AMPLITUDE
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inventory_node.add_item(item_id, quantity)
		player_inventory_node.refresh_inventory.emit()
		queue_free()
