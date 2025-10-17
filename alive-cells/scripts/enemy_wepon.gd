extends Area2D

var damage: int = 1


# Handle damaging the player
func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit(damage)
