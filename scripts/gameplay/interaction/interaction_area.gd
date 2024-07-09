extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"
@export var interact_type: String = ""

enum InteractPositions { UP, DOWN, LEFT, RIGHT }

@export var interact_position: InteractPositions = InteractPositions.UP
var pos: String = ""

var interact: Callable = func():
	pass

func _ready() -> void:
	match interact_position:
		InteractPositions.UP:
			pos = "up"
		InteractPositions.DOWN:
			pos = "down"
		InteractPositions.LEFT:
			pos = "left"
		InteractPositions.RIGHT:
			pos = "right"


func _on_body_entered(body:Node2D) -> void:
	InteractionManager.register_area(self, interact_type)

func _on_body_exited(body:Node2D) -> void:
	InteractionManager.unregister_area(self)
