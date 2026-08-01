extends Area2D


var is_empty: bool:
	get:
		return !has_overlapping_areas() && !has_overlapping_bodies()

@onready var viewport := get_viewport()


func _ready() -> void:
	var screen_center: Vector2i = viewport.size / 2
	global_position = screen_center
