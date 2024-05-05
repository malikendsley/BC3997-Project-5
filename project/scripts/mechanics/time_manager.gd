extends Node

# SIGNALS
signal time_tick(time: float, day:int, hour:int, minute:int)
signal day_to_night
signal night_to_day

# IF YOU'RE GONNA CHANGE VARIABLES, CHANGE THESE:
@export var INGAME_SPEED = 20.0
@export var INITIAL_HOUR = 12
@export var DAY_BEGIN_HOUR: int = 6
@export var DAY_END_HOUR: int = 18

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

var time:float= 0.0
var past_time:int= -1
var past_is_day = null
var past_hour = -1

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR

func _process(delta: float) -> void:
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	_recalculate_time()	

# Gets total time of game in minutes
func get_time() -> int:
	return int(time / INGAME_TO_REAL_MINUTE_DURATION)

func get_day() -> int:
	return int(get_time() / MINUTES_PER_DAY)

func get_hour() -> int:
	var current_day_minutes = get_time() % MINUTES_PER_DAY
	return int(current_day_minutes / MINUTES_PER_HOUR)

func get_minute() -> int:
	var current_day_minutes = get_time() % MINUTES_PER_DAY
	return int(current_day_minutes % MINUTES_PER_HOUR)

func get_time_float() -> float:
	return time
	
func is_day() -> bool:
	var hour = get_hour()
	if DAY_BEGIN_HOUR <= hour and hour < DAY_END_HOUR:
		return true
	return false

func _recalculate_time() -> void:
	var curr_time: int = get_time()
	
	if past_time == curr_time:
		return
	
	var hour: int = get_hour()
	past_time = curr_time
	time_tick.emit(get_day(), hour, get_minute())
	
	if hour == past_hour:
		return
	
	var is_day: bool = is_day()
	if !past_is_day and is_day:
		night_to_day.emit()
	elif past_is_day and !is_day:
		day_to_night.emit()
	past_is_day = is_day
	
	
