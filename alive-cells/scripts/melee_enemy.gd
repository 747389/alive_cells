extends CharacterBody2D

const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MAX_DISTANCE_Y: int = 100

var player: Node
var hp: int = 4
var in_range: bool = false


func _ready() -> void:
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		var distance_y = abs(player.position.y - position.y)
		if distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y:
			if not in_range:
				$Node2D/sprite/AnimationPlayer.play("walk")
			else:
				$Node2D/sprite/AnimationPlayer.play("RESET")
			if player.global_position.x > self.global_position.x:
				$Node2D.scale.x = 1
				velocity.x = SPEED
			else:
				velocity.x = -SPEED
				$Node2D.scale.x = -1
		else:
			$Node2D/sprite/AnimationPlayer.play("RESET")
			velocity.x = 0
		move_and_slide()



func hit():
	hp -= 1
	if hp <= 0:
		queue_free()


func boom():
	hp -= 7
	if hp <= 0:
		queue_free()


func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = true


func _on_detection_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = false
