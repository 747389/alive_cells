extends Area2D

const SPEED: float = 20.0


func _physics_process(delta: float) -> void:
	move_local_x(SPEED)


func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit()
		body.hit()
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_meta("wepon"):
		queue_free()
