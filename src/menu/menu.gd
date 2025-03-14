extends Control


func _on_play_btn_button_up() -> void:
	_load_level(0)


func _on_settings_btn_button_up() -> void:
	pass # Replace with function body.



func _load_level(level):
	Events.emit_signal("load_level", level)
