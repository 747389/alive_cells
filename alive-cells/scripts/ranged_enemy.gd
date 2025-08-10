extends CharacterBody2D

const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MIN_DISTANCE_X: int = 200
const MAX_DISTANCE_Y: int = 100
const AIM_RIGHT: float = 0
const AIM_LEFT: float = deg_to_rad(180)


var player: Node
var hp: int = 3
var can_shoot: bool = true
var flip_direction_right: bool

@export var bullet_scene: PackedScene


func _ready() -> void:
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		var distance_y = abs(player.position.y - position.y)
		if distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y:
			if can_shoot:
				var bullet = bullet_scene.instantiate()
				$gun.add_sibling(bullet)
				bullet.global_position = $gun.global_position
				
				if flip_direction_right:
					bullet.rotation = AIM_RIGHT
				else:
					bullet.rotation = AIM_LEFT
				
				$shoot_timer.start()
				can_shoot = false
				
			if player.global_position.x > self.global_position.x:
				$gun.scale.x = 1
				flip_direction_right = true
			else:
				$gun.scale.x = -1
				flip_direction_right = false
		move_and_slide()


func hit():
	hp -= 1
	if hp <= 0:
		queue_free()


func boom():
	hp -= 7
	if hp <= 0:
		queue_free()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
