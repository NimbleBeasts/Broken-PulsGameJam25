extends Node2D

@export var strength: int = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("set_jumppad"):
		#$PopSound.play()
		body.set_jumppad(strength)
		$AnimationPlayer.play("pop")
