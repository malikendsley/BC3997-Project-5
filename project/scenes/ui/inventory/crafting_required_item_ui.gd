extends Control

const texture_template = "res://project/textures/items/%s.png"

var item_quantity: Label = null
var item_texture: TextureRect = null

var item_id: String = ""
var quantity: int = 0

func get_child_nodes():
	item_quantity = get_node("QuantityContainer/Quantity")
	item_texture = get_node("IconContainer/TextureRect")

func update_labels_and_textures():
	item_quantity.text = "x%d" % quantity
	item_texture.texture = load(texture_template % item_id)

func initialize(my_item_id:String, my_quantity:int):
	get_child_nodes()
	item_id = my_item_id
	quantity = my_quantity
	update_labels_and_textures()
