class_name PlayerStateJump extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	player.update_animation("jump")
	player.player_animation.pause()
	player.add_debug_indicator(Color.GREEN)
	player.velocity.y = -player.jump_force

func exit() -> void:
	player.coyote_timer = 0.0

func handle_input(event: InputEvent) -> PlayerState:
	if Input.is_action_just_pressed("Airdash")  and player.can_airdash:
		return airdash
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return null

func process(_delta: float) -> PlayerState:
	set_jump_frame()
	return null

func physics_process(_delta: float) -> PlayerState:	
	if player.velocity.y > 0:
		return fall
	
	player.velocity.x = player.direction.x * player.base_move_speed
	return null

func set_jump_frame() -> void:
	var frame: float = remap(player.velocity.y, -player.jump_force, 0.0, 0.0, 0.8)
	player.player_animation.seek(frame, true)
