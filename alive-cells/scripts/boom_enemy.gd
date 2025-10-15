extends CharacterBody2D

const FAST_SPEED: float = 400.0
const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MAX_DISTANCE_Y: int = 100
const LOW_DISTANCE_X: int = 300
const EXPLOSION_DAMAGE: int = 7
const KNOCKBACK_TIMER: float = 0.3
const BOOM_TIMER: float = 0.4

var can_boom: bool = true
var hp: int = 3
var player: Node
var taking_knockback: bool = false

@export var boom_scene: PackedScene
@export var boom_animationplayer: Node
@export var color_rect: Node


# Stops animation and finds the player
func _ready() -> void:
	boom_animationplayer.play("RESET")
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	# Gets the playes postion
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		var distance_y = abs(player.position.y - position.y)

		# Handes moving towords the player when in range
		if (
			distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y 
			and distance_x >= LOW_DISTANCE_X
		):
			if player.global_position.x > self.global_position.x:
				velocity.x += SPEED * delta
			else:
				velocity.x += -SPEED * delta
		elif distance_x <= LOW_DISTANCE_X:
			if player.global_position.x > self.global_position.x:
				velocity.x += FAST_SPEED * delta
			else:
				velocity.x += -FAST_SPEED * delta
		else:
			velocity.x += 0
		move_and_slide()


# Handle damging the player and other enemys
func _on_boom_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		body.hit(EXPLOSION_DAMAGE)
	if body.has_meta("enemy"):
		body.hit(EXPLOSION_DAMAGE,0 ,0)


# Handle taking damage and knockback form the player
func hit(damage, direction, knockback):
	hp -= damage
	if hp <= 0:
		queue_free()
	if knockback > 0:
		taking_knockback = true
		velocity.x = knockback * direction
		await get_tree().create_timer(KNOCKBACK_TIMER).timeout
		taking_knockback = false


# Handel exsploding
func _on_triger_body_entered(body: Node2D) -> void:
	if body.has_meta("player") and can_boom:
		await get_tree().create_timer(BOOM_TIMER).timeout
		boom_animationplayer.play("boom")
		color_rect.visible = false
		velocity.x = 0
		var boom = boom_scene.instantiate()
		boom.position = self.global_position
		boom.emitting = true
		add_sibling(boom)
		can_boom = false


# Makes it die after exsploding
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var boom_animation: String = "boom"
	if anim_name == boom_animation:
		queue_free()
