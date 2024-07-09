extends Control

@onready var check_label = $BGCanvasLayer/Panel/MarginContainer/Label
@onready var validate_http = $CheckIDToken

var logdate = {
	"last_login_date": {}
}

func _ready():
	validate_http.request_completed.connect(_on_token_check_completed)
	await get_tree().create_timer(2.0).timeout
	if FileAccess.file_exists("user://user_info.save"):
		Firebase.user_info = FileAccess.open("user://user_info.save", FileAccess.READ).get_var()

		logdate.last_login_date = Time.get_date_string_from_system()

		Firebase.update_document("users/%s.json" % Firebase.user_info.id, logdate, validate_http)
	else:
		check_label.text = "User not found. Redirecting to Login..."
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file("res://scenes/account_management/LoginScreen.tscn")


func _on_token_check_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	if response_code == 200:
		check_label.text = "User found! Redirecting to Main Menu..."
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")
	else:
		check_label.text = "User not found. Redirecting to Login..."
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file("res://scenes/account_management/LoginScreen.tscn")