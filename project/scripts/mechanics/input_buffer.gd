# Simple input buffer system
extends Node

# 9 frames, like in SSBB. Many players are unconsciously used to this buffer window
const BUFFER_WINDOW := 150
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
			timestamps["mouseclick"] = Time.get_ticks_msec()
			
# return true if the action is buffered, false otherwise. Consumes the action if it is buffered
func consume_action(action: String) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			if timestamps.has(event.keycode):
				if Time.get_ticks_msec() - timestamps[event.keycode] <= BUFFER_WINDOW:
					# consume the action
					debounce(action)
					return true;
	return false

func consume_mouse_click() -> bool:
	if timestamps.has("mouseclick"):
		if Time.get_ticks_msec() - timestamps["mouseclick"] <= BUFFER_WINDOW:
			debounce("mouseclick")
			return true
	return false

# reset the timestamp for the given action, so that it can be buffered again
func debounce(action: String) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var keycode = event.keycode
			if timestamps.has(keycode):
				timestamps[keycode] = 0
