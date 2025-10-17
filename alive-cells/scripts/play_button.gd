extends Button

const LEVEL_SCENE: String = "res://scenes/level.tscn"


# Go to level when presed
func _on_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file" , LEVEL_SCENE)
