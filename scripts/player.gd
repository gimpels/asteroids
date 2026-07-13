extends CharacterBody2D


@export var speed := 10.0
@export var maximum_speed := 400.0
@export var rotation_speed := 200.0

@onready var sprite: Sprite2D = $Sprite2D

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
	wraparound()

func wraparound() -> void:
	var screen_size := get_viewport_rect().size
	var sprite_size := sprite.texture.get_size() * sprite.scale

	var hx: float = sprite_size.x / 2
	var hy: float = sprite_size.y / 2

	global_position.x = wrapf(global_position.x, -hx, screen_size.x + hx)
	global_position.y = wrapf(global_position.y, -hy, screen_size.y + hy)
