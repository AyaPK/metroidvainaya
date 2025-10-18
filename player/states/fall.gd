class_name PlayerStateFall extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.add_debug_indicator()
	pass

func exit() -> void:
	if player.is_on_floor():
		player.coyote_timer = player.coyote_time

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.y += player.gravity * _delta
	player.coyote_timer -= _delta
	
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0:
		return jump
	
	if player.is_on_floor():
		if player.direction.x == 0:
			return idle
		else:
			return run
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
