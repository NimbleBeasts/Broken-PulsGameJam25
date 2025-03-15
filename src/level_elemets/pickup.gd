extends Node2D

@export var type: Types.PickupType = Types.PickupType.Life

func _ready() -> void:
	$Sprite2D.frame = type

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(type)
		queue_free()
