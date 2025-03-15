extends Node2D

var decay: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not decay:
		$AnimationPlayer.play("decay")
		decay = true
	
