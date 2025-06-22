extends CharacterBody2D

const SPEED: float = 100.0
const MAX_DISTANCE: int = 500

var player: Node
var hp: int = 3


func _ready() -> void:
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		if distance_x <= MAX_DISTANCE:
			if player.global_position.x > self.global_position.x:
				$Node2D.scale.x = 1
				velocity.x = SPEED
			else:
				velocity.x = -SPEED
				$Node2D.scale.x = -1
		else:
			velocity.x = 0
		move_and_slide()



func hit():
	hp -= 1
	if hp <= 0:
		queue_free()
