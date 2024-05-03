# Simple sound manager, autoloaded
# Allows you to play sounds with a single line of code
# (Particularly useful for sounds that extend beyond the life of their source)

class_name SoundManager

const sound_template = "res://project/sounds/"
const sound_extension = ".wav"

@export var sounds = {
    "test": preload (sound_template + "test" + sound_extension),
}

func play_sound(sound_id):
    if sounds.has(sound_id):
        var sound = sounds[sound_id].duplicate()
        sound.play()
    else:
        print("Sound not found: " + sound_id)