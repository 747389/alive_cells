extends CharacterBody2D

const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MAX_DISTANCE_Y: int = 100

var player: Node
var hp: int = 4
var in_range: bool = false
var taking_knockback: bool = false
@export var walking_animation: Node


# Finding the player
func _ready() -> void:
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	# Gets the players pisition
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		var distance_y = abs(player.position.y - position.y)

		# Handes anmation and moving towords the player when in range
		if distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y:
			if not in_range:
				walking_animation.play("walk")
			else:
				walking_animation.play("RESET")
			if player.global_position.x > self.global_position.x and not taking_knockback:
				$Node2D.scale.x = 1
				velocity.x = SPEED
			elif not taking_knockback:
				velocity.x = -SPEED
				$Node2D.scale.x = -1
		else:
			walking_animation.play("RESET")
			velocity.x = 0
		move_and_slide()


# Handels taking damage form the player 
func hit(damage, direction, knockback):
	hp -= damage
	if hp <= 0:
		queue_free()
	if knockback > 0:
		taking_knockback = true
		velocity.x = knockback * direction
		await get_tree().create_timer(0.3).timeout
		taking_knockback = false


# Seeing when the player is in attack range 
func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = true


# Seeing when the player leaves attack range
func _on_detection_body_exited(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = false
