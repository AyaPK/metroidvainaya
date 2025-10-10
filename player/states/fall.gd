class_name PlayerStateFall extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.velocity.y += player.gravity * _delta
	
	if player.is_on_floor():
		if player.direction.x == 0:
			return idle
		else:
			return run
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
