@icon("res://assets/state.svg")
class_name PlayerState extends Node

var player: Player
var next_state: PlayerState

#region //state references
@onready var idle: PlayerState = $"../Idle"
@onready var run: PlayerState = $"../Run"
#endregion

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state

func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	return next_state
