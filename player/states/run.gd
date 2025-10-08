class_name PlayerStateRun extends PlayerState

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
	if player.direction.x == 0:
		return idle
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
