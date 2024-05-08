extends Control

const main_menu_scene = "res://project/scenes/ui/main_menu/main_menu.tscn"

func goto_main_menu():
    get_tree().change_scene_to_file(main_menu_scene)