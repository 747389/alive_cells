extends Area2D

@export var player: Node
@export var Node2d: Node
var attack_damage: int = 1
var charge_attack_damage: int = 2
var attack_knockback: int = 0
var charge_attack_knockback: int = 500


# handle attaking an enemy
func _on_body_entered(body: Node2D) -> void:
	if not body == player:
		if player.charge_attack:
			body.hit(charge_attack_damage, Node2d.scale.x, charge_attack_knockback)
		else:
			body.hit(attack_damage, Node2d.scale.x, attack_knockback)
