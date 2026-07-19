class_name Asteroid extends Area2D

signal exploded(position, size)

enum AsteroidSize { BIG, MEDIUM, SMALL, TINY }
@export var size := AsteroidSize.BIG

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var screen_wrap := $ScreenWrap

var direction := Vector2(0, -1)
var speed := 100.0

func _ready() -> void:
	rotation = randf_range(0, 2 * PI)

	match size: 
		AsteroidSize.BIG:
			speed = randf_range(100, 150)
			sprite.texture = preload("res://assets/textures/meteor_big1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_coll_shape_big1.tres"))

		AsteroidSize.MEDIUM:
			speed = randf_range(150, 200)
			sprite.texture = preload("res://assets/textures/meteor_medium1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_coll_shape_medium1.tres"))

		AsteroidSize.SMALL:
			speed = randf_range(200, 250)
			sprite.texture = preload("res://assets/textures/meteor_small1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_coll_shape_small1.tres"))

		AsteroidSize.TINY:
			speed = randf_range(250, 300)
			sprite.texture = preload("res://assets/textures/meteor_tiny1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_coll_shape_tiny1.tres"))

	screen_wrap.target_body = self
	screen_wrap.size = sprite.texture.get_size()

func _physics_process(delta: float) -> void:
	global_position += direction.rotated(rotation) * speed * delta

func explode() -> void:
	emit_signal("exploded", global_position, size)
	queue_free()
