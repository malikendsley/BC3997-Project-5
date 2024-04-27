extends Control

const texture_template = "res://project/textures/items/%s.png"

var item_button:BaseButton = null

var item_label: Label = null
var item_quantity: Label = null
var item_texture: TextureRect = null

var item_id: String = ""
var item_name: String = ""
var quantity: int = 0
var is_equippable: bool = false

func get_child_nodes():
	item_button = get_node("ItemButton")
	item_label = get_node("Right/LabelContainer/Label")
	item_quantity = get_node("Left/QuantityContainer/Quantity")
	item_texture = get_node("Left/IconContainer/TextureRect")

func update_labels_and_textures():
	item_label.text = item_name
	item_quantity.text = "x%d" % quantity
	item_texture.texture = load(texture_template % item_id)

func initialize(my_item_id:String, my_quantity:int):
	get_child_nodes()
	item_id = my_item_id
	item_name = Items.get_item_name(my_item_id)
	is_equippable = Items.is_equippable(my_item_id)
	quantity = my_quantity
	update_labels_and_textures()

func _on_item_button_pressed():
	pass
