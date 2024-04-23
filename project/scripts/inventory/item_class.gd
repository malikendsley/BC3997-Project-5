#class_name ItemClass
#extends Node
#
## enum for item types
#enum ItemType {
	#WEAPON,
	#RESOURCE
#}
#
#var id: String
#var item_name: String
#var item_type: ItemType
#var recipe: ItemClass
#var is_craftable: bool
#var is_equippable: bool
