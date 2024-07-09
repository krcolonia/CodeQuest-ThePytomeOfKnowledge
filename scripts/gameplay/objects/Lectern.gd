extends Node2D

@onready var interaction_area: InteractionArea = $Sprite2D/InteractionArea
@onready var sprite = $Sprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	get_tree().call_group("ui", "show_code_ui")
