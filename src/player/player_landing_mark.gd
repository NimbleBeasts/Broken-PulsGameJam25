extends Node2D

func _ready() -> void:
	$Sprite2D.frame = randi() % 2
