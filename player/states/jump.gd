class_name PlayerStateJump extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.velocity.y = -player.jump_force

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.y += player.gravity * _delta
	
	if player.velocity.y > 0:
		return fall
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
