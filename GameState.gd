extends Node

var total_score: int
var collected_modules: Array[Module]
var level: int

var main_menu: String = "res://Scenes/MainMenu/MainMenu.tscn"

func _ready():
	restart()

func restart():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file(main_menu)
	total_score = 0
	collected_modules = []
	level = 1
