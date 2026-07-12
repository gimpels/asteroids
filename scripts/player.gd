extends CharacterBody2D


@export var speed := 10.0
@export var maximum_speed := 400.0
@export var rotation_speed := 200.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_forward", "move_backward")
	var input_vector := Vector2(0, direction)
	
	velocity += input_vector.rotated(rotation) * speed
	velocity = velocity.limit_length(maximum_speed)
	
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed * delta))

	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	var screen_size := get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
