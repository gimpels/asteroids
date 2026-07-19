extends Node2D

@onready var lasers := $Lasers
@onready var player := $Player
@onready var asteroids := $Asteroids

var asteroid_scene := preload("res://scenes/asteroid.tscn")

func _ready() -> void:
	player.connect("laser_shot", _on_player_laser_shot)

	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)

func _on_asteroid_exploded(asteroid_position: Vector2, size: Asteroid.AsteroidSize) -> void:
	match size:
		Asteroid.AsteroidSize.BIG:
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.MEDIUM)
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.MEDIUM)

		Asteroid.AsteroidSize.MEDIUM:
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.SMALL)
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.SMALL)

		Asteroid.AsteroidSize.SMALL:
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.TINY)
			spawn_asteroid(asteroid_position, Asteroid.AsteroidSize.TINY)

		Asteroid.AsteroidSize.TINY:
			pass

func spawn_asteroid(asteroid_position: Vector2, size: Asteroid.AsteroidSize) -> void:
	var asteroid := asteroid_scene.instantiate()
	asteroid.global_position = asteroid_position
	asteroid.size = size
	asteroid.connect("exploded", _on_asteroid_exploded)

	asteroids.add_child.call_deferred(asteroid)
