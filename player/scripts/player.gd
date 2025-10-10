class_name Player extends CharacterBody2D

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
@export var gravity: float = 980
@export var base_move_speed: int = 150
@export var jump_force: float = 400.0
@export var coyote_time: float = 0.1
@export var rotation_speed: float = 10.0
#endregion

func _ready() -> void:
	initialise_states()

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	
func _process(_delta: float) -> void:
	_update_direction()
	change_state(current_state.process(_delta))

func _physics_process(_delta: float) -> void:
	change_state(current_state.physics_process(_delta))
	move_and_slide()
	_update_rotation(_delta)

func _update_direction() -> void:
	#var prev_direction: Vector2 = direction
	var x_axis: float = Input.get_axis("left", "right")
	var y_axis: float = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)

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
