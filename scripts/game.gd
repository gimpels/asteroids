extends Node2D

var asteroid_scene := preload("res://scenes/asteroid.tscn")

@onready var lasers := $Lasers
@onready var player := $Player
@onready var asteroids := $Asteroids
@onready var hud := $UserInterface/HeadsUpDisplay
@onready var game_over := $UserInterface/GameOver
@onready var player_spawn_area := $PlayerSpawnArea

@onready var score: int = 0:
	set(value):
		score = value
		hud.score = score

@onready var lives: int = 3:
	set(value):
		lives = value
		hud.set_lives(lives)

func _ready() -> void:
	game_over.visible = false
	lives = 3
	score = 0

	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)

	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_player_laser_shot(laser: Variant) -> void:
	lasers.add_child(laser)


func _on_player_died() -> void:
	lives -= 1

	if lives <= 0:
		await get_tree().create_timer(1).timeout
		game_over.visible = true
	else:
		await get_tree().create_timer(1).timeout

		while !player_spawn_area.is_empty:
			await get_tree().create_timer(0.1).timeout

		player.respawn()


func _on_asteroid_exploded(asteroid_position: Vector2, size: Asteroid.AsteroidSize, points: int) -> void:
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

	score += points


func spawn_asteroid(asteroid_position: Vector2, size: Asteroid.AsteroidSize) -> void:
	var asteroid := asteroid_scene.instantiate()
	asteroid.global_position = asteroid_position
	asteroid.size = size
	asteroid.connect("exploded", _on_asteroid_exploded)

	asteroids.add_child.call_deferred(asteroid)
