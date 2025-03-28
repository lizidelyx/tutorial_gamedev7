extends Interactable
@export var sceneName = "Level 1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
