class_name PlayerStateIdle extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.velocity.x = 0

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	if Input.is_action_just_pressed("jump"):
		return jump
	elif Input.is_action_just_pressed("down"):
		return crouch
	if player.direction.x != 0:
		return run
	if !player.is_on_floor():
		return fall
	return null
