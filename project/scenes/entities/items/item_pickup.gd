class_name ItemPickup
extends CharacterBody2D

# TODO: Could pull these strings into a separate file for easier maintenance
const texture_template = "res://project/textures/items/%s.png"

@export var item_id: String = "wood"
@export var quantity: int = 1

@export var item_texture: Sprite2D
var collectible = true
var touching = false

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
	if item_texture == null:
		item_texture = %ItemSprite
	update_item(item_id)

func _process(delta):
	if collectible:
		if touching:
			Player.get_singleton().inventory.add_item(item_id, quantity)
			queue_free()
		curr_time += delta
		velocity.y = sin(curr_time * TIME_MULTIPLIER) * BOUNCE_AMPLITUDE
		move_and_slide()

# Changes the item's ID (what it is) and updates the texture (how it looks)
func update_item(new_id: String):
	self.item_id = new_id
	item_texture.texture = load(texture_template % item_id)

func set_collectible(c):
	collectible = c

func _on_area_2d_body_entered(body):
	if body is Player:
		touching = true

func _on_area_2d_body_exited(body):
	if body is Player:
		touching = false