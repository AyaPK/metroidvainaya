class_name Shadow extends Node2D

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	sprite.modulate = Color(1.0, 1.0, 1.0, 0.596)

func _process(delta: float) -> void:
	sprite.modulate.a -= 3*delta
	if sprite.modulate.a <= 0:
		queue_free()
