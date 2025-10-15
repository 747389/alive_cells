extends CharacterBody2D

const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MAX_DISTANCE_Y: int = 100
const AIM_RIGHT: float = 0
const AIM_LEFT: float = deg_to_rad(180)
const COLLISION_DAMAGE: int = 1
const COLLISION_DAMAGE_TIMER: float = 0.5

var player: Node
var hp: int = 3
var can_shoot: bool = true
var flip_direction_right: bool
var being_stood_on: bool = false

@export var bullet_scene: PackedScene
@export var gun: Node
@export var shoot_timer: Node


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

		# Handel sooting when the player is in range
		if distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y:
			if can_shoot:
				var bullet = bullet_scene.instantiate()
				gun.add_sibling(bullet)
				bullet.global_position = gun.global_position
				
				if flip_direction_right:
					bullet.rotation = AIM_RIGHT
				else:
					bullet.rotation = AIM_LEFT
				
				shoot_timer.start()
				can_shoot = false
				
			if player.global_position.x > self.global_position.x:
				gun.scale.x = 1
				flip_direction_right = true
			else:
				gun.scale.x = -1
				flip_direction_right = false


# Handle taking damage from the player 
func hit(damage, _direction, _knockback):
	hp -= damage
	if hp <= 0:
		queue_free()


# Shoot timer
func _on_shoot_timer_timeout() -> void:
	can_shoot = true


# Damage the player if standing on them
func _on_damage_area_body_entered(body: Node2D) -> void:
	being_stood_on = true
	while body.has_meta("player") and being_stood_on:
		body.hit(COLLISION_DAMAGE)
		await get_tree().create_timer(COLLISION_DAMAGE_TIMER).timeout


# Stop damageing the player if not standing on them
func _on_damage_area_body_exited(body: Node2D) -> void:
	being_stood_on = false
