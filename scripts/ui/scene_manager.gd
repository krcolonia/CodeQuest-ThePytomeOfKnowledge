extends CanvasLayer

# ? Game UI and Assets
var dialogic_style = load("res://assets/dialogic_styles/CustomDialogueTheme/DialogueStyle.tres")

# ? Main Menu
const MAIN_MENU = preload("res://scenes/menus/MainMenu.tscn")

# ? Level 1 Scenes
const LEVEL1_HOME = preload("res://scenes/levels/level1/Lvl1_Interiors.tscn")
const LEVEL1_TOWN = preload("res://scenes/levels/level1/Lvl1_Exterior.tscn")

@onready var color_rect =  $ColorRect
@onready var label = $MarginContainer/Label
@onready var animplayer = $AnimationPlayer

var player

func _ready() -> void:
	color_rect.hide()
	label.hide()

func change_stage(stage_path, x, y, starting_dir) -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	self.layer = 10
	color_rect.show()
	label.show()
	animplayer.play("start_transition")
	await animplayer.animation_finished

	var stage = stage_path.instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(stage)

	player = stage.get_node("Game Objects").find_child("Player") # HACK: This is a slower method of finding the Player node in a game level's scene tree.
	get_tree().call_group("player", "starting_direction", starting_dir)
	player.position = Vector2(x,y)

	await get_tree().create_timer(1.0).timeout

	animplayer.play("end_transition")
	await animplayer.animation_finished
	self.layer = 0
	color_rect.hide()
	label.hide()

func return_mainmenu() -> void:
	var stage_index = int(get_tree().get_root().get_child_count()) - 1

	self.layer = 10
	color_rect.show()
	label.show()
	animplayer.play("start_transition")
	await animplayer.animation_finished

	var stage = MAIN_MENU.instantiate()
	get_tree().get_root().get_child(stage_index).free()
	get_tree().get_root().add_child(stage)

	await get_tree().create_timer(1.0).timeout

	animplayer.play("end_transition")
	await animplayer.animation_finished
	self.layer = 0
	color_rect.hide()
	label.hide()
