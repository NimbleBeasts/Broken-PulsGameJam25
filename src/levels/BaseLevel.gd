extends Node2D


var pressed = false
var current_line: Line2D = null

func _ready() -> void:
	Events.connect("flash", _flash)
	$AnimationPlayer.play("fade_out")
	


func _flash():
	$AnimationPlayer.play("flash")


func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if pressed:
			#Continue drawing
			current_line.add_point(mouse_pos)
			$PreviewDoodle.remove_child(current_line)
			$PreviewDoodle.add_child(current_line)
			Global.ink_count += 1
		else:
			#Start new
			pressed = true
			start_new_line(mouse_pos)
			Global.ink_count += 10
	else:
		if pressed:
			$PreviewDoodle.remove_child(current_line)
			$Doodles.add_child(current_line)
		pressed = false
	
	$Label.set_text(str(mouse_pos)) 

func start_new_line(start_pow: Vector2):
	current_line = Line2D.new()
	current_line.width = 2
	current_line.add_point(start_pow)
	$PreviewDoodle.add_child(current_line)
	


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#pressed = event.pressed
			#
			#if pressed:
				#$Line2D.add_point(event.position - $Player/Camera2D.position)
		#elif event is InputEventMouseMotion and pressed:
			#$Line2D.add_point(event.position - $Player/Camera2D.position)
			#print(current_line)
