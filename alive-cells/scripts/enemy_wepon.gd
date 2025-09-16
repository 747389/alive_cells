extends Area2D


# handle damaging the player
func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit(1)
