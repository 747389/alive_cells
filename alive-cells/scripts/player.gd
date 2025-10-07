extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -350.0
const MAX_CHARGE: float = 1.0
const NO_CHARGE: float = 0.1

var charge_attack: bool = false
var charge: float = 0
var attack: bool = false
var potion_stage: int = 5
var max_potion_stage: int = 5
var potion_stage_info: Dictionary = {
	"1" = "res://assests/potions ( all empty).png",
	"2" = "res://assests/potions (3 empty).png",
	"3" = "res://assests/potions (2 empty).png",
	"4" = "res://assests/potion (1 empty).png",
	"5" = "res://assests/potions (full).png",
}
var coins: int = 0
var health_clamp: int = 10
var health_potions: int = 4
var max_health_potions: int = 4
var health_gained: int = 2
var max_health: int = 10
var double_jump: int = 1
var health: int:
	get:
		return health_clamp
	set(value):
		health_clamp = min(value, max_health)

@export var coins_ui: Node
@export var health_ui: Node
@export var wepon_animation: Node


func _physics_process(delta: float) -> void:
	# Gravty
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump and double jump
	if (Input.is_action_just_pressed("W") and is_on_floor() or Input.is_action_just_pressed("W") 
		and double_jump > 0):
			velocity.y = JUMP_VELOCITY
			double_jump -= 1
	if is_on_floor():
		double_jump = 1

	# Handle mooving
	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * SPEED
		$Node2D.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Reset attack variables when starting to attack
	if Input.is_action_just_pressed("Space"):
		attack = true
		charge_attack = false

	# Handels chrging an attack and what attack the player is doing
	if attack:
		if Input.is_action_just_released("Space") and charge < MAX_CHARGE and attack:
			if not wepon_animation.current_animation == "player_attack":
				wepon_animation.play("player_attack")
			attack = false
		elif Input.is_action_pressed("Space"):
			if (
					charge <= NO_CHARGE and attack 
					and not wepon_animation.current_animation == "player_attack"
			):
				wepon_animation.play("charge")
			charge += delta
		if Input.is_action_just_released("Space"):
			if charge >= MAX_CHARGE:
				attack = false
				wepon_animation.play("charge_attack")
				charge_attack = true
			else:
				attack = false
			charge = 0

	# Mooves the player down 1 px to go thurogh 2 way platforms
	if Input.is_action_just_pressed("S") and is_on_floor():
		position.y += 1

	move_and_slide()

	# Handle healing
	if Input.is_action_just_pressed("Q") and health_potions >= 1 and health < max_health:
		health_potions -= 1
		health += health_gained
		health_ui.value = health
		potion_stage -= 1
		$"Potions(full)".texture = load(potion_stage_info[str(potion_stage)])


# Handle taking damage
func hit(damage):
	health -= damage
	health_ui.value = health
	if health <= 0:
		get_tree().call_deferred("change_scene_to_file" , "res://scenes/main_menu.tscn")



func _on_area_entered(area: Area2D) -> void:
	# Handle colting coins
	if area.has_meta("coin"):
		coins += 1
		area.queue_free()
		coins_ui.text = str(coins) + " x"

	# Handle refilling potions
	if area.has_meta("refill"):
		for stage in potion_stage_info:
			if int(stage) < potion_stage:
				continue
			$"Potions(full)".texture = load(potion_stage_info[str(stage)])
			await get_tree().create_timer(0.4).timeout
		potion_stage = max_potion_stage
		health_potions = max_health_potions
