# Represents an instance of damage and associated information
# Concerned parties look into this object to determine the effects of the damage

class_name DamageInstance

enum Faction {
	NONE, # Damages no one, useful to enforce that a faction is set
	PLAYER, # Comes from the player, damages enemies (for example)
	HOSTILE, # Comes from enemies, damages the player (for example)
}

# Fields such as amount, source, and type of damage can go here

var damage: int
var faction: Faction
var source: Node

var position: Vector2

func _init(_damage: int, _faction: Faction, _source: Node, _position: Vector2):
	damage = _damage
	faction = _faction
	source = _source
	position = _position

# Other methods can go here
