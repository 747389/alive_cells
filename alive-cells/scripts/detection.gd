extends Area2D

var player: Node
var attack_animation_player: Node
var can_attack: bool = false
var in_range: bool = false


func _ready() -> void:
	attack_animation_player = get_node("../../AnimationPlayer")


func _process(_delta: float) -> void:
	if in_range and can_attack:
		attack_animation_player.play("enemy_attack")
		can_attack = false
		$Timer.start()


func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("player"):
		in_range = true
		$Timer.start()


func _on_timer_timeout() -> void:
	can_attack = true


func _on_body_exited(_body: Node2D) -> void:
	in_range = false
