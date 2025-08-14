extends Area2D

@export var player: Node


func _on_body_entered(body: Node2D) -> void:
	if not body == player:
		if player.charge_attack:
			body.hit(2)
		else:
			body.hit(1)
