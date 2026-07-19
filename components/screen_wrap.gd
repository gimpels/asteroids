class_name ScreenWrap
extends Node2D

@export var target_body: Node2D
@export var size: Vector2

@onready var viewport := get_viewport()

func _physics_process(_delta: float) -> void:
	wraparound()

func wraparound() -> void:
	var screen_size: Vector2i = viewport.size
	var body_size := size * target_body.global_scale

	var hx: float = body_size.x / 2
	var hy: float = body_size.y / 2

	target_body.global_position.x = wrapf(target_body.global_position.x, -hx, screen_size.x + hx)
	target_body.global_position.y = wrapf(target_body.global_position.y, -hy, screen_size.y + hy)
