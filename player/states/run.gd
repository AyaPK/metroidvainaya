class_name PlayerStateRun extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.update_animation("run")

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	if Input.is_action_just_pressed("jump"):
		return jump
	elif Input.is_action_just_pressed("down"):
		return crouch
	return null

func physics_process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle
	if !player.is_on_floor():
		return fall
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
