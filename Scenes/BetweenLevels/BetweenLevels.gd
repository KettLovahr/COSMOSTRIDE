extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$ColorRect/LevelCompleteText.text = "Level %02d completed!\nCurrent Total Score %06d" % [GameState.level, GameState.total_score]


func _on_continue_button_pressed():
	GameState.level += 1
	get_tree().change_scene_to_file("res://Scenes/MainScene/MainScene.tscn")
