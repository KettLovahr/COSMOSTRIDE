extends Node

var total_score: int
var collected_modules: Array[Dictionary]
var level: int

var main_menu: String = "res://Scenes/MainMenu/MainMenu.tscn"

var module_icons: Dictionary = {
	"SHIELD": "res://Scenes/Player/ModuleIcons/module_shield.png",
	"SPEED": "res://Scenes/Player/ModuleIcons/module_speed.png",
	"BARREL_ROLL": "res://Scenes/Player/ModuleIcons/module_barrel_roll.png",
	"SHOT_SPEED": "res://Scenes/Player/ModuleIcons/module_shot_speed.png",
	"SHOT_DAMAGE": "res://Scenes/Player/ModuleIcons/module_shot_damage.png",
	"TWIN_FIRE": "res://Scenes/Player/ModuleIcons/module_twin_fire.png",
	"REGEN": "res://Scenes/Player/ModuleIcons/module_regen.png",
}

func _ready():
	restart()

func restart():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file(main_menu)
	total_score = 0
	collected_modules = []
	level = 1
