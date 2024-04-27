extends Control

const texture_template = "res://project/textures/items/%s.png"
var crafting_item_scene = preload("res://project/scenes/ui/inventory/crafting_required_item_ui.tscn")

var recipe_container:BoxContainer = null
var entry_button:BaseButton = null

var item_label: Label = null
var item_texture: TextureRect = null

var item_id: String = ""
var item_name: String = ""
var can_craft:bool = false

func get_child_nodes():
	recipe_container = get_node("HBoxContainer")
	entry_button = get_node("ItemButton")
	item_label = get_node("InfoSide/Right/LabelContainer/Label")
	item_texture = get_node("InfoSide/Left/IconContainer/TextureRect")

func remove_children(parent):
	for n in parent.get_children():
		parent.remove_child(n)
		n.queue_free()

func add_items_node(item:String, quantity: int):
	var crafting_item_instance = crafting_item_scene.instantiate()
	crafting_item_instance.initialize(item, quantity)
	recipe_container.add_child(crafting_item_instance)

func gen_recipe():
	var item_recipe:Dictionary = Items.get_recipe(item_id)
	for item_id in item_recipe:
		var quantity: int = item_recipe[item_id]
		add_items_node(item_id, quantity)

func update_labels_and_textures():
	item_label.text = item_name
	item_texture.texture = load(texture_template % item_id)

func initialize(my_item_id:String, my_can_craft: bool):
	get_child_nodes()
	item_id = my_item_id
	can_craft = my_can_craft
	print(can_craft)
	item_name = Items.get_item_name(my_item_id)
	update_labels_and_textures()

	remove_children(recipe_container)
	gen_recipe()

func _on_item_button_pressed():
	pass
