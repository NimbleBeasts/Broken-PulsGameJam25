extends CharacterBody2D

const DEFAULT_GRAVITY = Vector2(0, 9)
const JUMP_FORCE = 200
const BOUNCE_FORCE = 150
const JUMP_FORCE_EXTERNAL = 280
const JUMP_FORCE_JUMPPAD = 450
const STOP_FORCE_FLOOR = 550
const STOP_FORCE_AIR = 20
const STOP_FORCE_LADDER = 800
const WALK_FORCE = 1200
const LADDER_FORCE = 1200
const MAX_SPEED = 96
const LADDER_CORRECTION_SPEED = 120

enum PlayerState {Normal, Ladder}
enum RecordEvent {Move, Anim, Shoot}

var counter = 0

var state = {
	"ghost_no": -1,
	"dead": false,
	"last_record_id": 0,
	"current_state": PlayerState.Normal,
	"suspend_respawn": false,
	"pickup": [],
	"ghost_anim_end": false,

	# Movement
	"velocity": Vector2(0,0),
	"jumping": false,
	"has_jumped": false,
	"air_time": 0,
	"ladder_area": null,
	"has_bullet": true,
	"extern_jump": false,
	"bounce": false,
	"jumppad": false,
}

func get_direction_input():
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("game_right")) - int(Input.is_action_pressed("game_left"))
	input.y = int(Input.is_action_pressed("game_down")) - int(Input.is_action_pressed("game_up"))
	return input
	

func _physics_process(delta):
	
	if Global.debugLabel:
		Global.debugLabel.set_text("Ink: " + str(Global.ink_count))
	
	if global_position.y > 666 and not state.dead:
		die()
		return
	if not state.dead:
		var input_direction = get_direction_input()
		update_animation()
			
		match state.current_state:
			PlayerState.Normal:
				process_movement(delta, input_direction)
			PlayerState.Ladder:
				process_ladder(delta, input_direction)
			_:
				pass
			
		if Input.is_action_just_pressed("game_flash"):
			Global.ink_count += 10
			Events.emit_signal("flash")


func update_animation():
	var anim = ""

	if state.current_state == PlayerState.Ladder:
		pass
	else:
		if abs(state.velocity.x) > 0.1:
			anim = "walk"
		else:
			anim = "idle"
		if state.velocity.y > 32:
			anim = "falling"
		elif state.velocity.y < 0:
			anim = "jump"

	if $AnimationPlayer.current_animation == "shoot":
		return

	if $AnimationPlayer.current_animation != anim:
		$Label.set_text("play: " + str(anim))
		$AnimationPlayer.play(anim)

func die():
	state.dead = true


func process_movement(delta, input_direction):
	var on_floor_or_ghost = is_on_floor()

	# Jumping
	if on_floor_or_ghost:
		# Reset Jump state
		state.jumping = false
		state.has_jumped = false
		state.air_time = 0
	else:
		state.air_time += 1 # TODO: use delta - anyway do we need air time? xD

	if state.bounce:
		state.velocity.y =- BOUNCE_FORCE
		state.bounce = false

	if state.jumppad:
		#$JumpSound.play()
		state.velocity.y =- JUMP_FORCE_JUMPPAD
		state.jumppad = false

	if state.extern_jump:
		#$JumpSound.play()
		state.velocity.y =- JUMP_FORCE_EXTERNAL
		state.extern_jump = false

	if Input.is_action_just_pressed("game_jump") and on_floor_or_ghost and not state.jumping:
		#$JumpSound.play()
		state.velocity.y =- JUMP_FORCE
		state.jumping = true
		state.has_jumped = true

	# Stop movement
	if input_direction == Vector2(0.0, 0.0):
		var stop_force = delta
		if on_floor_or_ghost:
			stop_force *= STOP_FORCE_FLOOR
		else:
			stop_force *= STOP_FORCE_AIR

		if state.velocity.x > 0:
			state.velocity.x = max(state.velocity.x - stop_force, 0)
		elif state.velocity.x < 0:
			state.velocity.x = min(state.velocity.x + stop_force, 0)
	# Accelarete
	else:
		state.velocity.x += input_direction.x * delta * WALK_FORCE
		if state.velocity.x > MAX_SPEED:
			state.velocity.x = MAX_SPEED
		elif state.velocity.x < -MAX_SPEED:
			state.velocity.x = -MAX_SPEED

	if input_direction.x == -1:
		$SpriteHolder.scale.x = -1
	elif input_direction.x == 1:
		$SpriteHolder.scale.x = 1

	state.velocity.y += DEFAULT_GRAVITY.y
	set_velocity(state.velocity)
	set_up_direction(Vector2(0, -1))
	move_and_slide()
	state.velocity = velocity

func process_ladder(delta, input_direction):
	var on_floor_or_ghost = is_on_floor()

	if state.ladder_area:
		if position.x != state.ladder_area.global_position.x:
			if position.x < state.ladder_area.global_position.x:
				position.x += LADDER_CORRECTION_SPEED*delta
			else:
				position.x -= LADDER_CORRECTION_SPEED*delta

			if abs(state.ladder_area.global_position.x - position.x) < 2:
				position.x = state.ladder_area.global_position.x
			return

	# Quit ladder on jump
	if Input.is_action_just_pressed("game_jump"):
		state.current_state = PlayerState.Normal
		return

	# Stop movement
	if input_direction.y == 0.0:
		var stop_force = STOP_FORCE_LADDER*delta
		if state.velocity.y > 0:
			state.velocity.y = max(state.velocity.x - stop_force, 0)
		elif state.velocity.y < 0:
			state.velocity.y = min(state.velocity.x + stop_force, 0)
	# Accelarete
	else:
		state.velocity.y += input_direction.y * delta * LADDER_FORCE
		if state.velocity.y > MAX_SPEED:
			state.velocity.y = MAX_SPEED
		elif state.velocity.y < -MAX_SPEED:
			state.velocity.y = -MAX_SPEED

	set_velocity(state.velocity)
	set_up_direction(Vector2(0, -1))
	move_and_slide()
	state.velocity = velocity
