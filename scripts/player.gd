class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died()

@export var speed := 10.0
@export var maximum_speed := 500.0
@export var rotation_speed := 300.0
@export var fire_rate := 0.1

var shoot_cooldown := false
var laser_scene := preload("res://scenes/laser.tscn")

var alive = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var screen_wrap := $ScreenWrap
@onready var muzzle := $Muzzle
@onready var viewport := get_viewport()


func _ready() -> void:
	set_init_position()
	screen_wrap.size = sprite.texture.get_size()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true

			shoot_laser()
			await get_tree().create_timer(fire_rate).timeout

			shoot_cooldown = false


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


func set_init_position() -> void:
	var screen_center: Vector2i = viewport.size / 2
	global_position = screen_center


func shoot_laser() -> void:
	var laser = laser_scene.instantiate()
	laser.global_position = muzzle.global_position
	laser.rotation = rotation

	emit_signal("laser_shot", laser)


func die() -> void:
	if alive:
		alive = false
		emit_signal("died")

		sprite.visible = false
		process_mode = Node.PROCESS_MODE_DISABLED


func respawn() -> void:
	if not alive:
		alive = true

		rotation = 0
		velocity = Vector2.ZERO
		set_init_position()

		sprite.visible = true
		process_mode = Node.PROCESS_MODE_INHERIT
