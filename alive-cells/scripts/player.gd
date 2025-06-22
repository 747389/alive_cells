extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_attack: bool = true
var _health: int = 10
var health_potions: int = 3
var health_gained: int = 3
var max_health: int = 10
var health: int:
	get:
		return _health
	set(value):
		_health = min(value, max_health)




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("W") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * SPEED
		$Node2D.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("shift") and can_attack:
		$Node2D/wepon/AnimationPlayer.play("player_attack")
		can_attack = false
		$attack.start()
	move_and_slide()

	if Input.is_action_just_pressed("Q") and health_potions >= 1:
		health_potions -= 1
		health += health_gained


func _on_attack_timeout() -> void:
	can_attack = true


func hit():
	health -= 1
	if health <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/test.tscn")
