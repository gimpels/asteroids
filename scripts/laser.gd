extends Area2D

const DIRECTION := Vector2(0, -1)

@export var speed := 500.0


func _physics_process(delta: float) -> void:
	global_position += DIRECTION.rotated(rotation) * speed * delta


func _on_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	var asteroid: Asteroid = area

	if asteroid:
		asteroid.explode()
		queue_free()
