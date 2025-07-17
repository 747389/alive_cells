extends StaticBody2D

var can_flip: bool = true


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("S") and can_flip:
		$CollisionShape2D.scale.y = -1
		$Timer.start()
		can_flip = false


func _on_timer_timeout() -> void:
	$CollisionShape2D.scale.y = 1
	can_flip = true


func hit():
	pass
