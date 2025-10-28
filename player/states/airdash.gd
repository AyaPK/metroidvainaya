class_name PlayerStateAirdash extends PlayerState

var fall_gravity_multiplier: float = 0
var dash_dir: Vector2
var dash_timer: float
var ghost_timer: float

func init() -> void:
	pass

func enter() -> void:
	player.can_airdash = false
	dash_dir = player.direction 
	player.velocity = Vector2.ZERO
	player.gravity_multiplier = fall_gravity_multiplier
	dash_timer = player.airdash_time
	ghost_timer = 0.01

func exit() -> void:
	dash_timer = 0
	player.gravity_multiplier = 1.0
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func process(_delta: float) -> PlayerState:
	if dash_dir == Vector2.ZERO:
		return fall
	if dash_timer <= 0.0:
		return fall
	if ghost_timer <= 0.0:
		player.spawn_shadow()
		ghost_timer = 0.01
	return null

func physics_process(delta: float) -> PlayerState:
	var dash_normalized = dash_dir.normalized()
	player.velocity.x = dash_normalized.x * (player.base_move_speed * 5)
	player.velocity.y = dash_normalized.y * (player.base_move_speed * 5)

	dash_timer -= delta
	ghost_timer -= delta

	if player.is_on_floor():
		return idle

	return null
