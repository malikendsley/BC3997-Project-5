# Simple sound manager, autoloaded
# Allows you to play sounds with a single line of code
# (Particularly useful for sounds that extend beyond the life of their source)
extends Node

const sound_template = "res://project/sounds/"
const sound_extension = ".wav"

var sounds = {
    "test": preload (sound_template + "test" + sound_extension),
}

var sfx_player: AudioStreamPlayer

func _ready():
    sfx_player = AudioStreamPlayer.new()
    add_child(sfx_player)

# TODO: Create support for arbitrary number of channel
func play_sound(sound_id):
    if sounds.has(sound_id):
        sfx_player.stream = sounds[sound_id]
        sfx_player.call_deferred("play")
    else:
        print("Sound not found: " + sound_id)
