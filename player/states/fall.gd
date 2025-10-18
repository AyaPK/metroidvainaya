class_name PlayerStateFall extends PlayerState

var fall_gravity_multiplier: float = 1.365

func init() -> void:
	pass

func enter() -> void:
	player.update_animation_state("fall")
	player.gravity_multiplier = fall_gravity_multiplier
	player.add_debug_indicator()
	pass

func exit() -> void:
	player.gravity_multiplier = 1.0
	player.set_collision_mask_value(5, true)
	if player.is_on_floor():
		player.coyote_timer = player.coyote_time

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		player.buffer_timer = player.jump_buffer
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	player.coyote_timer -= delta
	player.buffer_timer -= delta
	
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0:
		return jump
	
	if player.is_on_floor():
		if player.buffer_timer > 0:
			return jump
		if Input.is_action_pressed("down"):
			return crouch
		if player.direction.x == 0:
			return idle
		else:
			return run
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
