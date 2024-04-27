class_name Enemy
extends Entity

func handle_destroyed(_d_i: DamageInstance) -> void:
    super(_d_i)
    inventory.drop_inventory_on_ground()
    queue_free()
