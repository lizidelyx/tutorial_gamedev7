extends Area3D
@export var sceneName := "Level 1"

  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body., m


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.get_name() == "Player":
		get_tree().change_scene_to_file(str("res://scenes/" + sceneName + ".tscn"))
