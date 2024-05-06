extends Node

const PATH = "user://settings.cfg"
var config = ConfigFile.new()

func _ready():
    reset_save()
    load_save()

func reset_save() -> void:
    #Set default VIDEO settings
    config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
    config.set_value("Video", "borderless", false)
    config.set_value("Video", "vsync", DisplayServer.VSYNC_ENABLED)

    for i in range(3):
        config.set_value("Audio", str(i), 1.0)

func save_data() -> void:
    config.save(PATH)

func load_save() -> void:
    if config.load(PATH) != OK:
        print("Error loading settings file, creating new one")
        save_data()
        return

    print("Settings file loaded")
    load_video_settings()

func load_video_settings() -> void:
    var screen_type = config.get_value("Video", "fullscreen")
    DisplayServer.window_set_mode(screen_type)
    
    var borderless = config.get_value("Video", "borderless")
    DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderless)
    
    var vsync_index = config.get_value("Video", "vsync")
    DisplayServer.window_set_vsync_mode(vsync_index)

func load_audio_settings() -> void:
    for i in range(3):
        config.get_value("Audio", str(i), 1.0)