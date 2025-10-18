class_name PlayerStateCrouch extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.update_animation_state("crouch")

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state

func process(_delta: float) -> PlayerState:
	if !Input.is_action_pressed("down"):
		return idle
	elif Input.is_action_just_pressed("jump"):
		if player.is_on_one_way_platform():
			player.global_position.y += 1
		else:
			return jump
	elif !player.is_on_floor():
		return fall
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = move_toward(player.velocity.x, 0,12)
	return next_state
