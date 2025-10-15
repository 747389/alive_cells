extends Area2D

var can_attack: bool = false
var in_range: bool = false

@export var attack_animationplayer: Node
@export var attack_timer: Node


# Handle attacking
func _process(_delta: float) -> void:
	if in_range and can_attack:
		attack_animationplayer.play("enemy_attack")
		can_attack = false
		attack_timer.start()


# Handle detection of the player
func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = true
		attack_timer.start()


func _on_timer_timeout() -> void:
	can_attack = true


func _on_body_exited(_body: Node2D) -> void:
	in_range = false
