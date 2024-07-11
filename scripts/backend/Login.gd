extends Control

# ? User Inputs
@onready var email = $InputCanvas/PageInputMargin/InputVBox/Email/LineEdit
@onready var password = $InputCanvas/PageInputMargin/InputVBox/Password/LineEdit

# ? Submit/Login Button
@onready var login_button = $InputCanvas/PageInputMargin/InputVBox/SubmitMargin/LoginButton

# ? Redirecto to Register Button
@onready var redirect_register_button = $InputCanvas/PageInputMargin/InputVBox/RedirectRegister/Button

# ? Popup Alert Nodes
@onready var popup_canvas = $PopupCanvas
@onready var popup_title = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/PopupTitle
@onready var popup_message = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/PopupMessage

@onready var popup_close = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupClose
@onready var popup_confirm = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupConfirm

# ? HTTPRequest Node
@onready var auth_http = $AuthenticationRequest
@onready var db_http = $RealtimeDBRequest

var save_path = "user://user_info.save"

func _ready() -> void:
	close_popup()
	$InputCanvas/CanvasModulate.show()
	$AnimationPlayer.play("fade_in")
	popup_close.pressed.connect(self._on_popclose_pressed)
	popup_confirm.pressed.connect(self._on_popconfirm_pressed)

func _on_login_button_pressed():
	# TODO: change all print calls into UI elements
	if email.text.is_empty():
		print("Fill the E-mail input!")
		return
	
	if password.text.is_empty():
		print("Fill the Password input!")
		return

	# ? Calls the 'login' function from the autoloaded Firebase class
	Firebase.login(email.text, password.text, auth_http)

var logdate = {
	"last_login_date" : {}
}

func _on_authentication_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		await get_tree().create_timer(1.5).timeout

		logdate.last_login_date = Time.get_date_string_from_system()

		Firebase.update_document("users/%s.json" % Firebase.user_info.id, logdate, db_http)
	else:
		set_custom_popup("Error " + str(response_code), json.error.message.capitalize(), true, false)

func _on_realtime_db_request_completed(_result:int, response_code:int, _headers:PackedStringArray, _body:PackedByteArray) -> void:
	if response_code == 200:
		set_custom_popup("Login Successful", "Login Successful. Redirecting to Main Menu...", false, false)
		await get_tree().create_timer(1.5).timeout
		var file
		if !FileAccess.file_exists(save_path):
			file = FileAccess.open(save_path, FileAccess.WRITE)
		else:
			file = FileAccess.open(save_path, FileAccess.READ_WRITE)
		file.store_var(Firebase.user_info)

		close_popup()
		$AnimationPlayer.play("fade_out")
		await get_tree().create_timer(1.2).timeout
		get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")

func set_custom_popup(title: String, message: String, show_close: bool, show_confirm: bool):
	popup_title.text = title
	popup_message.text = message
	
	if show_close == true:
		popup_close.show()
	
	if show_confirm == true:
		popup_confirm.show()
	
	popup_canvas.show()

func _on_popclose_pressed():
	close_popup()

func _on_popconfirm_pressed():
	close_popup()
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")

func close_popup():
	popup_canvas.hide()
	popup_close.hide()
	popup_confirm.hide()

func _on_redirect_register_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/account_management/RegisterScreen.tscn")
