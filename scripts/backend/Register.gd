extends Control

# ? User Input Nodes
@onready var fullname = $InputCanvas/PageInputMargin/InputVBox/FullName/LineEdit
@onready var email = $InputCanvas/PageInputMargin/InputVBox/Email/LineEdit
@onready var password = $InputCanvas/PageInputMargin/InputVBox/Password/LineEdit
@onready var confirm_pass = $InputCanvas/PageInputMargin/InputVBox/ConfirmPassword/LineEdit
# @onready var privacy_check = $InputCanvas/PageInputMargin/InputVBox/PrivacyPolicy/Checkbox

# ? Submit/Register Button Node
@onready var reg_button = $InputCanvas/PageInputMargin/InputVBox/SubmitMargin/RegisterButton

# ? Redirect to Login Button Node
@onready var redirect_login_btn = $InputCanvas/PageInputMargin/InputVBox/RedirectLogin/Button

# ? Popup Alert Nodes
@onready var popup_canvas = $PopupCanvas
@onready var popup_margin = $PopupCanvas/PopupMargin
@onready var popup_title = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/PopupTitle
@onready var popup_message = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/PopupMessage
@onready var scroll_message = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/ScrollContainer/PopupMessage
@onready var scroll_container = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/Panel/MessageMargin/ScrollContainer

@onready var popup_close = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupClose
@onready var popup_confirm = $PopupCanvas/PopupMargin/Panel/ContentMargin/ContentVBox/InputHBox/PopupConfirm

# ? HTTPRequest Node
@onready var auth_http = $AuthenticationRequest
@onready var db_http = $RealtimeDBRequest

# ! ^- these @onready vars just look like one big heap of cow dung
# !    I honestly do not know if there is a way to make this look
# !    prettier, but eh. If it works, it works! -krColonia

var profile := {
	"fullname" : {},
	"date_registered" : {}
}

func _ready():
	close_popup()
	$InputCanvas/CanvasModulate.show()
	$AnimationPlayer.play("fade_in")
	popup_close.pressed.connect(self._on_popclose_pressed)
	popup_confirm.pressed.connect(self._on_popconfirm_pressed)

func _on_register_button_pressed():
	if fullname.text.is_empty():
		set_custom_popup("Input Invalid!", false, "Please enter your Full Name", true, false, 420, 420)
		return
	
	if email.text.is_empty():
		set_custom_popup("Input Invalid!", false, "Please enter your E-mail Address", true, false, 420, 420)
		return
	
	if password.text.is_empty():
		set_custom_popup("Input Invalid!", false, "Please enter a password for your account", true, false, 420, 420)
		return
	
	if password.text != confirm_pass.text:
		set_custom_popup("Input Invalid!", false, "Passwords do not match", true, false, 420, 420)
		return
	
	# if !privacy_check.is_pressed():
	# 	set_custom_popup("Input Invalid!", false, "Please check the checkbox after reading the Privacy Policy.", true, false, 420, 420)
	# 	return

	# ? Calls the 'register' function from the autoloaded Firebase class
	Firebase.register(email.text, password.text, auth_http)

func _on_authentication_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		
		await get_tree().create_timer(1.5).timeout
		# ! ^- This is a really hacky-sorta way of doing it, I should find a way
		# !    to wait for the HTTPRequest to actually finish rather than
		# !    setting a 1.5 second timer. What if the request took longer?
		# !    This is why you don't trust me with backend stuff. -krColonia

		profile.fullname = fullname.text
		profile.date_registered = Time.get_date_string_from_system()
		
		Firebase.save_document("users/%s.json" % Firebase.user_info.id, profile, db_http)
	else:
		set_custom_popup("Error " + str(response_code), false, json.error.message.capitalize(), true, false, 420, 420)

func _on_realtime_db_request_completed(_result:int, response_code:int, _headers:PackedStringArray, _add_constant_forcebody:PackedByteArray):
	print(response_code)
	if response_code == 200:
		set_custom_popup("Registration Successful", false, "You may now continue to login your account", false, true, 420, 420)

func set_custom_popup(title: String, scroll_msg: bool, message: String, show_close: bool, show_confirm: bool, top: int, bottom: int):
	popup_title.text = title
	if !scroll_msg:
		scroll_container.hide()
		popup_message.show()
		popup_message.text = message
	else:
		scroll_container.show()
		popup_message.hide()
		scroll_message.text = message

	popup_margin.margin_top = top
	popup_margin.margin_bottom = bottom

	if show_close == true: popup_close.show()
	if show_confirm == true: popup_confirm.show()

	popup_canvas.show()

func _on_popclose_pressed():
	close_popup()

func _on_popconfirm_pressed():
	close_popup()
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://scenes/account_management/LoginScreen.tscn")

func close_popup():
	popup_canvas.hide()
	popup_close.hide()
	popup_confirm.hide()


func _on_redirect_login_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/account_management/LoginScreen.tscn")
