extends Area2D

const SPEED: float = 20.0

var damige: int = 2

# Moves the bullet
func _physics_process(delta: float) -> void:
	move_local_x(SPEED)


# Handle hitting the player
func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit(damige)
		queue_free()


# Handle being deflted by the plaer
func _on_area_entered(area: Area2D) -> void:
	if area.has_meta("wepon"):
		queue_free()
