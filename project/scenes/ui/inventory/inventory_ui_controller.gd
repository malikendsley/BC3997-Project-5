extends Node

var time_since_change : float = 0
const BUTTON_DELAY: float = 0.5

var inventory_items_container: BoxContainer = null
var crafting_entries_container: BoxContainer = null
var item_scene = preload("res://project/scenes/ui/inventory/inventory_item_ui.tscn")
var crafting_entry_scene = preload("res://project/scenes/ui/inventory/crafting_entry_ui.tscn")
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
	crafting_entries_container = get_node("CraftingControl/ScrollContainer/CraftingEntriesContainer")
	get_inventory_node()

func add_items_node(item:String, quantity: int):
	var item_node_instance = item_scene.instantiate()
	item_node_instance.initialize(item, quantity)
	inventory_items_container.add_child(item_node_instance)
	
func add_crafting_node(item:String, can_craft: bool):
	var crafting_entry_instance = crafting_entry_scene.instantiate()
	crafting_entry_instance.initialize(item, can_craft)
	crafting_entries_container.add_child(crafting_entry_instance)

func gen_items_list():
	for item_id in inventory.items:
		if not inventory.has_item(item_id):
			continue

		var quantity: int = inventory.get_quantity(item_id)
		add_items_node(item_id, quantity)

func gen_crafting_list():
	# First pass for items player can craft
	for item_id in Items.items:
		if not Items.is_craftable(item_id):
			continue
		if not inventory.can_craft(item_id):
			continue
		add_crafting_node(item_id, true)
	# Second pass for items player cannot yet craft
	for item_id in Items.items:
		if not Items.is_craftable(item_id):
			continue
		if inventory.can_craft(item_id):
			continue
		add_crafting_node(item_id, false)
	

func remove_children(parent):
	for n in parent.get_children():
		parent.remove_child(n)
		n.queue_free()

func refresh_inventory():
	remove_children(inventory_items_container)
	remove_children(crafting_entries_container)
	gen_items_list()
	gen_crafting_list()

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

