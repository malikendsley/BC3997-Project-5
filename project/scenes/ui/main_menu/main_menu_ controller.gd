extends Control
class_name MainMenu

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var tab_container: TabContainer = %TabContainer
# TODO: Update if needed
@export var game_scene_name = "res://project/game.tscn"

@onready var settings_menu: Control = %SettingsControl
@onready var main_menu: Control = %MainMenuControl

func _input(event):
	if event.is_action_pressed("ui_cancel") and settings_menu.visible:
		settings_menu.visible = false
		main_menu.visible = true

func _ready():
	main_menu.visible = true
	settings_menu.visible = false
	tab_container.current_tab = 0
	start_button.pressed.connect(start_game)
	settings_button.pressed.connect(settings_opened)
	quit_button.pressed.connect(quit_game)
	
func start_game():
	print("Start game")
	get_tree().change_scene_to_file(game_scene_name)

func settings_opened():
	print("Settings menu pressed")
	main_menu.visible = false
	settings_menu.visible = true

func back_to_main_menu():
	print("Back to main menu")
	main_menu.visible = true
	settings_menu.visible = false

func quit_game():
	get_tree().quit()
