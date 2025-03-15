extends Control


func _ready() -> void:
	$Main/h/PlayBtn.grab_focus()
	$Main.show()
	$Help.hide()

func _on_play_btn_button_up() -> void:
	_load_level(0)


func _on_settings_btn_button_up() -> void:
	pass # Replace with function body.



func _load_level(level):
	Events.emit_signal("load_level", level)


func _on_help_btn_button_up() -> void:
	$Help/h/BackBtn.grab_focus()
	$Main.hide()
	$Help.show()


func _on_back_btn_button_up() -> void:
	_ready()
