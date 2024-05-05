extends CanvasModulate

@export var gradient_texture:GradientTexture1D

func _ready():
	TimeManager.night_to_day.connect(_on_night_to_day)
	TimeManager.day_to_night.connect(_on_day_to_night)

func _process(delta: float) -> void:
	var time: float = TimeManager.get_time_float()
	
	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)

func _on_day_to_night():
	print("Day to Night")

func _on_night_to_day():
	print("Night to Day")
