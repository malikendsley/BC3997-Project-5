class_name InventoryItem
extends Control

signal item_selected(item_id: String)

const texture_template = "res://project/textures/items/%s.png"

var item_button: BaseButton = null

var item_label: Label = null
var item_quantity: Label = null
var item_texture: TextureRect = null

var item_id: String = ""
var item_name: String = ""
var quantity: int = 0
var is_equippable: bool = false

func get_child_nodes():
	item_button = %ItemButton
	item_label = %Label
	item_quantity = %Quantity
	item_texture = %ItemTexture

func update_labels_and_textures():
	item_label.text = item_name
	item_quantity.text = "x%d" % quantity
	item_texture.texture = load(texture_template % item_id)

func initialize(my_item_id: String, my_quantity: int):
	get_child_nodes()
	item_id = my_item_id
	item_name = Items.get_item_name(my_item_id)
	is_equippable = Items.is_equippable(my_item_id)
	quantity = my_quantity
	update_labels_and_textures()

func _on_item_button_pressed():
	item_selected.emit(item_id)
