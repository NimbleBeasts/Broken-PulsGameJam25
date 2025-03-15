extends CharacterBody2D

const DEFAULT_GRAVITY = Vector2(0, 420)



var triggered = false


func _physics_process(delta: float) -> void:
	if triggered:
		if not is_on_floor():
			velocity.y += DEFAULT_GRAVITY.y * delta
			move_and_slide()


func _on_detect_player_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("pickup"):
		if not triggered:
			$AnimationPlayer.play("awake")
			triggered = true
