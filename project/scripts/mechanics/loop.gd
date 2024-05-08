extends AudioStreamPlayer

func _process(_delta):
	# loop the track
	if not is_playing():
		play()
