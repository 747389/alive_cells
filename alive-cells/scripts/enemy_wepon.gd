extends Area2D

var player: Node


func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit()
