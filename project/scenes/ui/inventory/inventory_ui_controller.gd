class_name InventoryUIController
extends Control

signal item_selected(item_id: String)

@onready var inventory_items_container: BoxContainer = %InventoryItemsContainer
@onready var crafting_entries_container: BoxContainer = %CraftingEntriesContainer
var item_scene = preload ("res://project/scenes/ui/inventory/inventory_item_ui.tscn")
var crafting_entry_scene = preload ("res://project/scenes/ui/inventory/crafting_entry_ui.tscn")
var inventory: Inventory

func _ready():
	self.visible = false
	inventory = Player.get_singleton().inventory
	inventory.refresh_inventory.connect(refresh_inventory)

func add_items_node(item: String, quantity: int):
	var item_node_instance = item_scene.instantiate() as InventoryItem
	item_node_instance.initialize(item, quantity)
	inventory_items_container.add_child(item_node_instance)
	item_node_instance.item_selected.connect(on_item_selected)

func add_crafting_node(item: String, can_craft: bool):
	var crafting_entry_instance = crafting_entry_scene.instantiate() as CraftingEntry
	crafting_entry_instance.initialize(item, can_craft)
	crafting_entry_instance.inventory_changed.connect(refresh_inventory)
	crafting_entries_container.add_child(crafting_entry_instance)

func gen_items_list():
	# First pass for equippable items
	for item_id in inventory.items:
		if not Items.is_equippable(item_id):
			continue
		if not inventory.has_item(item_id):
			print("This shouldn't happen")
			continue

		add_items_node(item_id, inventory.get_quantity(item_id))
	
	# Second pass for consumable items
	for item_id in inventory.items:
		if not Items.is_consumable(item_id):
			continue
		if not inventory.has_item(item_id):
			print("This shouldn't happen")
			continue

		add_items_node(item_id, inventory.get_quantity(item_id))
	
	# Third pass for regular items
	for item_id in inventory.items:
		if Items.is_consumable(item_id) or Items.is_equippable(item_id):
			continue
		if not inventory.has_item(item_id):
			print("This shouldn't happen")
			continue

		add_items_node(item_id, inventory.get_quantity(item_id))

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

func close_inventory_screen():
	self.visible = false

func open_inventory_screen():
	print("opening inventory")
	refresh_inventory()
	self.visible = true

func on_item_selected(item_name: String):
	item_selected.emit(item_name)
