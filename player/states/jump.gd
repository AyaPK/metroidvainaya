class_name PlayerStateJump extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.update_animation_state("jump")
	player.add_debug_indicator(Color.GREEN)
	player.velocity.y = -player.jump_force

func exit() -> void:
	player.coyote_timer = 0.0

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:	
	if player.velocity.y > 0:
		return fall
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null
