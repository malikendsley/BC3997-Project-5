extends Node2D

@export var respawn_location: Vector2 = Vector2(0, 0)

@export var playerref: Player = null
@export var gameuiref: GameUIController = null
@export var tilemapref: TileMap = null

func _input(_event):
    # TODO: Pausing
    pass

# Respawn the player and clean up state and scene
func respawn():
    pass