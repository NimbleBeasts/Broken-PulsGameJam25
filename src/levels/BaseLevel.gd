extends Node2D


func _ready() -> void:
	Events.connect("flash", _flash)
	$AnimationPlayer.play("fade_out")


func _flash():
	$AnimationPlayer.play("flash")
