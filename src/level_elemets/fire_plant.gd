extends Node2D

func fire():
	Events.emit_signal("shoot_bullet", $FlameTrap/Marker2D.global_position)
	$AudioStreamPlayer2D.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
