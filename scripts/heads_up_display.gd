extends Control


const SCORE_TEXT := "SCORE: "
const LIFE_SCENE := preload("res://scenes/life.tscn")

var score := 0:
	set(value):
		score = value
		score_label.text = SCORE_TEXT + str(score)
		
@onready var score_label := $Score
@onready var lives := $Lives

# TODO: Optimize this function
func set_lives(n: int) -> void:
	for life in lives.get_children():
		life.queue_free()

	for i in n:
		var life = LIFE_SCENE.instantiate()
		lives.add_child(life)
