# Simple input buffer system
extends Node

# 9 frames, like in SSBB. Many players are unconsciously used to this buffer window
const BUFFER_WINDOW := 150
const LMBDOWN = "lmbdown"
const LMBUP = "lmbup"

var timestamps: Dictionary

func _ready() -> void:
	# maintain this even if the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	timestamps = {}

# hook into standard input event handling to record timestamps for all key presses
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_echo() or !event.pressed:
			return
		var keycode = event.keycode
		timestamps[keycode] = Time.get_ticks_msec()
	elif event is InputEventMouseButton:
		# check if was press
		if event.pressed:
			timestamps[LMBDOWN] = Time.get_ticks_msec()
		else:
			timestamps[LMBUP] = Time.get_ticks_msec()

# return true if the action is buffered, false otherwise. Consumes the action if it is buffered
func consume_action(action: String, custom_buffer: int=BUFFER_WINDOW) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			if timestamps.has(event.keycode):
				if Time.get_ticks_msec() - timestamps[event.keycode] <= custom_buffer:
					# consume the action
					debounce(action)
					return true;
	return false

# returns true if a mouse click has occurred within the buffer window, false otherwise
func consume_mouse_down(custom_buffer: int=BUFFER_WINDOW) -> bool:
	if timestamps.has(LMBDOWN):
		if Time.get_ticks_msec() - timestamps[LMBDOWN] <= custom_buffer:
			debounce(LMBDOWN)
			return true
	return false

# returns true if a mouse release has occurred within the buffer window, false otherwise
func consume_mouse_up(custom_buffer: int=BUFFER_WINDOW) -> bool:
	if timestamps.has(LMBUP):
		if Time.get_ticks_msec() - timestamps[LMBUP] <= custom_buffer:
			debounce(LMBUP)
			return true
	return false

# reset the timestamp for the given action, so that it can be buffered again
func debounce(action: String) -> void:
	if action == LMBDOWN or action == LMBUP:
		timestamps[action] = -INF
	else:
		for event in InputMap.action_get_events(action):
			if event is InputEventKey:
				var keycode = event.keycode
				if timestamps.has(keycode):
					timestamps[keycode] = -INF
