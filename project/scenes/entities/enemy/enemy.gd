class_name Enemy
extends Entity

# TODO: 

@export var enemy_id: String = "slime"

# on spawn, generate the loot this enemy is carrying (which will drop on death)
func _ready():
    super()
    var loot_id = Items.roll_loot_table(enemy_id)
    if loot_id != "":
        print("Adding loot")
        inventory.add_item(loot_id, randi() % 3 + 1)

func handle_destroyed(_d_i: DamageInstance) -> void:
    super(_d_i)
    inventory.drop_inventory_on_ground()
    queue_free()
