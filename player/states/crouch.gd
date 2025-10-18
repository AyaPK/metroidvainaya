class_name PlayerStateCrouch extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state

func process(_delta: float) -> PlayerState:
	if !Input.is_action_pressed("down"):
		return idle
	elif Input.is_action_just_pressed("jump"):
		return jump
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = move_toward(player.velocity.x, 0, 10)
	return next_state
