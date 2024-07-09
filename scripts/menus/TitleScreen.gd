extends Control

@onready var mainanim = $MainAnimation
@onready var titleanim = $BGCanvasLayer/TitleAnimation
@onready var labelanim = $InputLayer/LabelAnim

@onready var bg_canvas_modulate = $BGCanvasLayer/BGCanvasModulate
@onready var label_canvas_modulate = $InputLayer/InputModulate

func _ready():
	bg_canvas_modulate.show()
	label_canvas_modulate.show()
	await get_tree().create_timer(1.0).timeout
	titleanim.play("TitlePulse")
	labelanim.play("label_pulse")
	mainanim.play("fade_from_black")

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/CheckLogScreen.tscn")
