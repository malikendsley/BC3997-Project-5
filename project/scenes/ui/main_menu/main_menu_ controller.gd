extends Control

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

# TODO: Update if needed
@export var game_scene_name = "res://project/game.tscn"

# TODO: Settings menu 
@onready var settings_menu: Control = %SettingsControl
@onready var main_menu: Control = %MainMenuControl

func _ready():
    start_button.pressed.connect(start_game)
    settings_button.pressed.connect(settings_menu_pressed)
    quit_button.pressed.connect(quit_game)
    
func start_game():
    print("Start game")
    get_tree().change_scene_to_file(game_scene_name)

func settings_menu_pressed():
    print("Settings menu pressed")
    swap_menus()

func quit_game():
    get_tree().quit()

func swap_menus():
    main_menu.visible = !main_menu.visible
    settings_menu.visible = !settings_menu.visible