extends Control

func _on_start_btn_button_up():
	get_tree().change_scene_to_file("res://scenes/levels/level1/Home.tscn")


func _on_exit_btn_button_up():
	get_tree().quit()


func _on_logout_btn_pressed() -> void:
	if FileAccess.file_exists("user://user_info.save"):
		DirAccess.remove_absolute("user://user_info.save")
		print("User info exists locally: %s" % FileAccess.file_exists("user://user_info.save"))