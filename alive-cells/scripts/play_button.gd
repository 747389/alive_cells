extends Button

# Go to level when presed
func _on_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file" , "res://scenes/level.tscn")
