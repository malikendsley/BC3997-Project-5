# Currently only manages current equipped item

class_name Equipment
extends Node

signal item_equipped(item: String)

# may be useful to promote items to no longer being an inner class, might improve linting
var equipped_item: String

func get_equipped_item():
    return equipped_item

# Replace the currently equipped item with the new item
# Return the replaced item
func equip_item(new_item: String) -> String:
    var old_item = equipped_item
    equipped_item = new_item
    
    # may be useful for UI
    if old_item != new_item:
        item_equipped.emit(new_item)

    return old_item