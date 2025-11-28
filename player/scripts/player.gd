class_name Player extends CharacterBody2D

const DEBUG_JUMP_INDICATOR = preload("uid://belnbdxrh2xmt")
const SHADOW = preload("uid://b6g6fjcetnt3s")

#region /// onready
@onready var floor_checker: RayCast2D = $FloorChecker
@onready var player_animation: AnimationPlayer = $PlayerAnimation
@onready var sprite: Sprite2D = $Sprite
#endregion

#region /// State Machine vars
var states: Array[PlayerState]
var current_state: PlayerState :
	get: return states.front()
var previous_state: PlayerState :
	get: return states[1]
#endregion

#region /// standard vars
var direction: Vector2 = Vector2.ZERO
var coyote_timer: float = 0.0
var buffer_timer: float = 0.0
var can_airdash: bool = true
#endregion

#region /// Export vars
@export var gravity: float = 980
@export var gravity_multiplier: float = 1
@export var base_move_speed: int = 100
@export var jump_force: float = 340.0
@export var coyote_time: float = 0.125
@export var jump_buffer: float = 0.2
@export var rotation_speed: float = 10.0
@export var max_fall_velocity: float = 600
@export var airdash_time: float = 0.1
@export var inner_deadzone: float = 0.18
@export var outer_deadzone: float = 0.98
@export var crouch_mag_min: float = 0.22
@export var crouch_half_angle_deg: float = 40.0
#endregion

func _ready() -> void:
	initialise_states()

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	
func _process(_delta: float) -> void:
	_update_direction()
	change_state(current_state.process(_delta))

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * (_delta * gravity_multiplier)
	velocity.y = clampf(velocity.y, -1000, max_fall_velocity)
	change_state(current_state.physics_process(_delta))
	move_and_slide()
	_update_rotation(_delta)

func _update_direction() -> void:
	var prev_direction: Vector2 = direction
	var raw := Input.get_vector("left", "right", "up", "down")
	direction = _apply_radial_deadzone(raw, inner_deadzone, outer_deadzone)
	
	if prev_direction.x != direction.x:
		if direction.x < 0:
			sprite.flip_h = true
		elif direction.x > 0:
			sprite.flip_h = false

func _update_rotation(_delta: float) -> void:
	if is_on_floor():
		var target_rotation = get_floor_normal().angle() + PI / 2
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * _delta)
	else:
		rotation = lerp_angle(rotation, 0.0, rotation_speed * _delta)

func initialise_states() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self
		
	if states.size() == 0:
		return
		
	for state in states:
		state.init()
	
	change_state(current_state)
	current_state.enter()
	$Label.text = current_state.name


func change_state(new_state: PlayerState) -> void:
	if !new_state:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name

func _apply_radial_deadzone(v: Vector2, inner: float, outer: float) -> Vector2:
	var m := v.length()
	if m < inner:
		return Vector2.ZERO
	var t = clamp((m - inner) / max(outer - inner, 0.0001), 0.0, 1.0)
	return v.normalized() * t

func _is_in_sector(angle: float, center: float, half_width: float) -> bool:
	var d = abs(wrapf(angle - center, -PI, PI))
	return d <= half_width

func is_crouch_intent() -> bool:
	if direction == Vector2.ZERO:
		return false
	var mag := direction.length()
	if mag < crouch_mag_min:
		return false
	var angle := atan2(direction.y, direction.x)
	return _is_in_sector(angle, PI/2, deg_to_rad(crouch_half_angle_deg))

func add_debug_indicator(color: Color = Color.RED) -> void:
	var indicator: Node2D = DEBUG_JUMP_INDICATOR.instantiate()
	get_tree().root.add_child(indicator)
	indicator.global_position = global_position
	indicator.modulate = color
	await get_tree().create_timer(2).timeout
	indicator.queue_free()

func is_on_one_way_platform() -> bool:
	if floor_checker.is_colliding():
		return true
	return false

func update_animation(animation_name: String) -> void:
	player_animation.play(animation_name)

func spawn_shadow() -> void:
	var shadow: Shadow = SHADOW.instantiate()
	get_parent().add_child(shadow)
	shadow.global_position = global_position
	shadow.sprite.flip_h = sprite.flip_h
	shadow.sprite.frame = sprite.frame
	
