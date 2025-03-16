extends Node2D

@export var type: Types.PickupType = Types.PickupType.Life

func _ready() -> void:
	$Sprite2D.frame = type

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(type)
		$AudioStreamPlayer2D.play()
		$Sprite2D.hide()
		

func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
