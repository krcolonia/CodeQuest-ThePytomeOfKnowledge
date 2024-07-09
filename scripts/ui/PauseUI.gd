extends CanvasLayer

@onready var settings_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/SettingsBtn
@onready var mainmenu_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/MainMenuBtn
@onready var quit_btn = $MarginContainer/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/QuitGameBtn

func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.

func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")

func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()