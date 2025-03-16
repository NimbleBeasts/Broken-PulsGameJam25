extends Node2D


var pressed = false
var current_line: Line2D = null

@export var is_tutorial = false
@export var matches: int = 10

@onready var mark_scene = preload("res://src/player/PlayerLandingMark.tscn")
@onready var bullet_scene = preload("res://src/level_elemets/FireBullet.tscn")


func _ready() -> void:
	Events.connect("flash", _flash)
	Events.connect("light", _fire)
	Events.connect("hurt", _hurt)
	Events.connect("landing_mark", _landing_mark)
	Events.connect("cheat_light", _cheat_light)
	Events.connect("shoot_bullet", _shoot_bullet)
	
	start()


func start():
	$AnimationPlayer.play("fade_out")
	Events.emit_signal("flash")
	Global.time = 0
	Global.lifes = 5
	Global.matches_count = matches
	Global.ink_count = 100
	
	Events.emit_signal("hud_lifes", Global.lifes)
	Events.emit_signal("hud_matches", Global.matches_count)
	Events.emit_signal("hud_ink", Global.ink_count)
	Events.emit_signal("hud_time", Global.time)
	

func _shoot_bullet(pos):
	var bullet = bullet_scene.instantiate()
	$Bullets.add_child(bullet)
	bullet.global_position = pos
	
func _cheat_light():
	$AnimationPlayer.stop()
	$Level.modulate = Color(1, 1, 1, 1)
	$Background.modulate = Color(1, 1, 1, 1)
	$LightningTimer.stop()

func _landing_mark(pos):
	var mark = mark_scene.instantiate()
	$Marks.add_child(mark)
	mark.global_position = pos

func _flash():
	if $AnimationPlayer.current_animation != "fire":
		$AnimationPlayer.play("flash")

func _fire():
	$AnimationPlayer.play("fire")

func _hurt():
	$AnimationPlayer.play("hurt")

func _physics_process(delta: float) -> void:
	
	Global.time += delta
	Events.emit_signal("hud_time", Global.time)
	
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if pressed and Global.ink_count > 0:
			#Continue drawing
			var last_point = current_line.get_point_position(current_line.get_point_count() - 1)
			if mouse_pos != last_point:
				if mouse_pos.distance_to(last_point) > 2:
					current_line.add_point(mouse_pos)
					$PreviewDoodle.remove_child(current_line)
					$PreviewDoodle.add_child(current_line)
					Global.ink_count -= 1
					Events.emit_signal("hud_ink", Global.ink_count)
					if not $AudioStreamPlayer.is_playing():
						$AudioStreamPlayer.play()
		else:
			if Global.ink_count > 0:
				#Start new
				pressed = true
				start_new_line(mouse_pos)
				Global.ink_count -= 1
				Events.emit_signal("hud_ink", Global.ink_count)
	else:
		if pressed:
			$PreviewDoodle.remove_child(current_line)
			$Doodles.add_child(current_line)
			$AudioStreamPlayer.play()
		pressed = false
	

func start_new_line(start_pow: Vector2):
	current_line = Line2D.new()
	current_line.width = 2
	current_line.default_color = Color("#ecddba")
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


func _on_lightning_timer_timeout() -> void:
	Events.emit_signal("flash")
