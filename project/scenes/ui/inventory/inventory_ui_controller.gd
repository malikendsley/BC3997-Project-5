extends Node

var time_since_change : float = 0
const BUTTON_DELAY: float = 0.5

var inventory_items_container: BoxContainer = null
var item_scene = preload("res://project/scenes/ui/inventory/inventory_item_ui.tscn")
var inventory:Node2D = null

func get_inventory_node():
	var node_list = get_tree().get_nodes_in_group("player")
	if len(node_list) <= 0 or len(node_list) > 1:
		inventory = null
		print("inventory_ui_controller.gd error: Unexpected (non-1) number of nodes in group 'player'")
		return
	var player_node:CharacterBody2D = node_list[0]
	inventory = player_node.get_node("Inventory")

func _ready():
	self.visible = false
	inventory_items_container = get_node("InventoryControl/ScrollContainer/InventoryItemsContainer")
	get_inventory_node()

func add_items_node(item:String, quantity: int):
	var item_node_instance = item_scene.instantiate()
	item_node_instance.initialize(item, quantity)
	inventory_items_container.add_child(item_node_instance)

func gen_items_list():
	for item_id in inventory.items:
		if not inventory.has_item(item_id):
			continue

		var quantity: int = inventory.get_quantity(item_id)
		add_items_node(item_id, quantity)

func remove_children(parent):
	for n in parent.get_children():
		parent.remove_child(n)
		n.queue_free()

func refresh_inventory():
	remove_children(inventory_items_container)
	gen_items_list()
	pass

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
	refresh_inventory()
	self.visible = true

