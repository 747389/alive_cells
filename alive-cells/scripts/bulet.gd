extends Area2D

const SPEED: float = 20.0

var damige: int = 2


func _physics_process(delta: float) -> void:
	move_local_x(SPEED)


# handle hitting the player
func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit(damige)
		queue_free()


# handle being deflted by the plaer
func _on_area_entered(area: Area2D) -> void:
	if area.has_meta("wepon"):
		queue_free()
