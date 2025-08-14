extends CharacterBody2D

const FAST_SPEED: float = 400.0
const SPEED: float = 100.0
const MAX_DISTANCE_X: int = 500
const MAX_DISTANCE_Y: int = 100
const LOW_DISTANCE_X: int = 300

var can_boom: bool = true
var player: Node
var hp: int = 2
@export var boom_scene: PackedScene

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	for players in get_tree().get_nodes_in_group("player"):
		player = players


func _process(delta: float) -> void:
	if player:
		velocity += get_gravity() * delta
		var distance_x = abs(player.position.x - position.x)
		var distance_y = abs(player.position.y - position.y)
		if distance_x <= MAX_DISTANCE_X and distance_y <= MAX_DISTANCE_Y and distance_x >= LOW_DISTANCE_X:
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


func _on_boom_body_entered(body: Node2D) -> void:
	if body.has_meta("player") or body.has_meta("enemy"):
		body.hit(7)



func hit(damage):
	hp -= damage
	if hp <= 0:
		queue_free()


func _on_triger_body_entered(body: Node2D) -> void:
	if body.has_meta("player") and can_boom:
		await get_tree().create_timer(0.4).timeout
		$AnimationPlayer.play("boom")
		$ColorRect.visible = false
		velocity.x = 0
		var boom = boom_scene.instantiate()
		boom.position = self.global_position
		boom.emitting = true
		add_sibling(boom)
		can_boom = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boom":
		queue_free()
