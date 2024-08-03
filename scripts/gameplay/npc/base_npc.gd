extends Node2D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

@export var dialogue_name: String

enum FacingDirection { UP, DOWN, LEFT, RIGHT }

@export var facing_direction: FacingDirection

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	set_direction()

func _on_interact() -> void:
	Dialogic.start(dialogue_name)

func set_direction() -> void:
	match facing_direction:
		FacingDirection.UP:
			anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
		FacingDirection.DOWN:
			anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
		FacingDirection.LEFT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
		FacingDirection.RIGHT:
			anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
	anim_state.travel("Idle")

# ? When interacting from above
func _on_area_up_body_entered(_body:Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.UP)
	anim_state.travel("Idle")

func _on_area_up_body_exited(_body:Node2D) -> void:
	set_direction()

# ? When interacting from below
func _on_area_down_body_entered(_body:Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.DOWN)
	anim_state.travel("Idle")

func _on_area_down_body_exited(_body:Node2D) -> void:
	set_direction()

# ? When interacting from the left
func _on_area_left_body_entered(_body:Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.LEFT)
	anim_state.travel("Idle")

func _on_area_left_body_exited(_body:Node2D) -> void:
	set_direction()

# ? When interacting from the right
func _on_area_right_body_entered(_body:Node2D) -> void:
	anim_tree.set("parameters/Idle/blend_position", Vector2.RIGHT)
	anim_state.travel("Idle")

func _on_area_right_body_exited(_body:Node2D) -> void:
	set_direction()