extends AudioStreamPlayer2D

func _process(_delta):
    # loop the track
    if not is_playing():
        play()