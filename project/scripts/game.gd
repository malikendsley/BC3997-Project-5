class_name Game
extends Node2D

@onready var game_ui_controller: GameUIController = %GameUI

func _ready():
    get_script().set_meta(&"singleton", self)

# Returns this node from anywhere.
static func get_singleton() -> Game:
    return (Game as Script).get_meta(&"singleton") as Game