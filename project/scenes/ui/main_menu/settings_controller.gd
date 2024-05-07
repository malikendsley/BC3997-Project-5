extends Control

@onready var fullscreen_checkbox: CheckBox = %Fullscreen
@onready var borderless_checkbox: CheckBox = %Borderless
@onready var vsync_option: OptionButton = %VSync

@onready var master_audio_slider: HSlider = %MasterVolume
@onready var music_audio_slider: HSlider = %MusicVolume
@onready var sfx_audio_slider: HSlider = %SFXVolume

func _ready():
    var screen_type = SettingsSave.config.get_value("Video", "fullscreen")
    var borderless = SettingsSave.config.get_value("Video", "borderless")
    var vsync = SettingsSave.config.get_value("Video", "vsync")

    fullscreen_checkbox.button_pressed = screen_type
    borderless_checkbox.button_pressed = borderless
    vsync_option.selected = vsync

    master_audio_slider.value = SettingsSave.config.get_value("Audio", "0")
    music_audio_slider.value = SettingsSave.config.get_value("Audio", "1")
    sfx_audio_slider.value = SettingsSave.config.get_value("Audio", "2")

func _on_Fullscreen_button_toggled(button_pressed: bool) -> void:
    if button_pressed:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    SettingsSave.config.set_value("Video", "fullscreen", DisplayServer.window_get_mode())
    SettingsSave.save_data()

func _on_Borderless_button_toggled(button_pressed: bool) -> void:
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, button_pressed)
    SettingsSave.config.set_value("Video", "borderless", button_pressed)
    SettingsSave.save_data()

func _on_VSync_option_item_selected(idx: int) -> void:
    DisplayServer.window_set_vsync_mode(idx)
    SettingsSave.config.set_value("Video", "vsync", idx)
    SettingsSave.save_data()

func _on_MasterVolume_changed(value: float) -> void:
    set_volume(0, value)

func _on_MusicVolume_changed(value: float) -> void:
    set_volume(1, value)

func _on_SFXVolume_changed(value: float) -> void:
    set_volume(2, value)

func set_volume(which, val):
    AudioServer.set_bus_volume_db(which, linear_to_db(val))
    SettingsSave.config.set_value("Audio", str(which), val)
    SettingsSave.save_data()

func _on_Back_pressed():
    (get_parent() as MainMenu).back_to_main_menu()
