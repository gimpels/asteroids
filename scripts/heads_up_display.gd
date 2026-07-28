extends Control


const SCORE_TEXT := "SCORE: "

var score := 0:
	set(value):
		score = value
		score_label.text = SCORE_TEXT + str(score)
		
@onready var score_label := $Score
