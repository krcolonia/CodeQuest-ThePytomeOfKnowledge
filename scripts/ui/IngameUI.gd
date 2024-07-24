extends CanvasLayer
class_name IngameUI
# ? Action Pressed


@onready var game_controls = $Controls
@onready var upBtn = $Controls/Dpad/up/upBtn
@onready var downBtn = $Controls/Dpad/down/downBtn
@onready var leftBtn = $Controls/Dpad/left/leftBtn
@onready var rightBtn = $Controls/Dpad/right/rightBtn
@onready var pauseBtn = $Controls/pauseBtn

@onready var interactBtn = $Controls/InteractButton

@onready var code_ui = $CodingUI
@onready var code_input = $CodingUI/Panel/MarginContainer/VBoxContainer/CodeEdit
@onready var code_output = $CodingUI/Panel/MarginContainer/VBoxContainer/Output

@onready var pause_ui = $PauseUI

func _ready():
	upBtn.pressed.connect(_on_up_btn_pressed)
	downBtn.pressed.connect(_on_down_btn_pressed)
	leftBtn.pressed.connect(_on_left_btn_pressed)
	rightBtn.pressed.connect(_on_right_btn_pressed)
	
	upBtn.released.connect(_on_up_btn_released)
	downBtn.released.connect(_on_down_btn_released)
	leftBtn.released.connect(_on_left_btn_released)
	rightBtn.released.connect(_on_right_btn_released)

	interactBtn.hide()


func _on_up_btn_pressed():
	Input.action_press("ui_up")

func _on_down_btn_pressed():
	Input.action_press("ui_down")

func _on_left_btn_pressed():
	Input.action_press("ui_left")


func _on_right_btn_pressed():
	Input.action_press("ui_right")

# ? Action Released
func _on_up_btn_released():
	Input.action_release("ui_up")

func _on_down_btn_released():
	Input.action_release("ui_down")

func _on_left_btn_released():
	Input.action_release("ui_left")

func _on_right_btn_released():
	Input.action_release("ui_right")

func enable_interact_button() -> void:
	interactBtn.show()

func disable_interact_button() -> void:
	interactBtn.hide()

func _on_interact_button_pressed() -> void:
	var interact_event = InputEventAction.new()
	interact_event.action = "ui_interact"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)

func show_code_ui():
	get_tree().call_group("player", "stop_movement")
	game_controls.hide()
	code_ui.show()

func _on_close_coding_button_pressed() -> void:
	get_tree().call_group("player", "continue_movement")
	game_controls.show()
	code_ui.hide()

	code_input.text = ""
	code_output.text = "Output:"

func _on_pause_btn_pressed() -> void:
	game_controls.hide()
	pause_ui.show()


func _on_resume_btn_pressed() -> void:
	game_controls.show()
	pause_ui.hide()
