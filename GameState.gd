extends Node

var total_score: int
var equipped_modules: Array[Dictionary] = [
	{"type": "EMPTY"},
	{"type": "EMPTY"},
	{"type": "EMPTY"},
]
var level: int

var main_menu: String = "res://Scenes/MainMenu/MainMenu.tscn"

var module_icons: Dictionary = {
	"EMPTY": "res://Scenes/Player/ModuleIcons/module_empty.png",
	"SHIELD": "res://Scenes/Player/ModuleIcons/module_shield.png",
	"SPEED": "res://Scenes/Player/ModuleIcons/module_speed.png",
	"BARREL_ROLL": "res://Scenes/Player/ModuleIcons/module_barrel_roll.png",
	"SHOT_SPEED": "res://Scenes/Player/ModuleIcons/module_shot_speed.png",
	"SHOT_DAMAGE": "res://Scenes/Player/ModuleIcons/module_shot_damage.png",
	"TWIN_FIRE": "res://Scenes/Player/ModuleIcons/module_twin_fire.png",
	"REGEN": "res://Scenes/Player/ModuleIcons/module_regen.png",
}

var module_descriptions: Dictionary = {
	"EMPTY": "There's nothing here",
	"SHIELD": "Increases the amount of damage your ship can take",
	"SPEED": "Increases maneuverability, making it easier to dodge bullets",
	"BARREL_ROLL": "Allows your ship to dodge bullets in-place",
	"SHOT_SPEED": "Increases fire rate",
	"SHOT_DAMAGE": "Increases bullet damage",
	"TWIN_FIRE": "Allows your ship to fire from both guns simultaneously",
	"REGEN": "Allows your ship to automatically repair itself with time",
}

func _ready():
	soft_restart()

func restart():
	soft_restart()
	get_tree().change_scene_to_file(main_menu)

func soft_restart():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	total_score = 0
	equipped_modules = [
		{"type": "EMPTY", "level": 0},
		{"type": "EMPTY", "level": 0},
		{"type": "EMPTY", "level": 0},
	]
	level = 1
