extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverRect/FinalScoreLabel.text = "FINAL SCORE\n%06d at level %02d" % [GameState.total_score, GameState.level]


func _on_button_pressed():
	GameState.restart()
