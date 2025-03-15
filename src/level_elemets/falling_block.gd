extends Node2D

var decay: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not decay:
		$AnimationPlayer.play("decay")
		decay = true

func deactivate_collision():
	$StaticBody2D.collision_layer = 0
	$StaticBody2D.collision_mask = 0
	$Respawn.start()


func _on_respawn_timeout() -> void:
	$StaticBody2D.collision_layer = 1
	$StaticBody2D.collision_mask = 1
	$AnimationPlayer.play("RESET")
	decay = false
	
