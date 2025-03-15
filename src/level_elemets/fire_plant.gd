extends Node2D

func fire():
	Events.emit_signal("shoot_bullet", $FlameTrap/Marker2D.global_position)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
