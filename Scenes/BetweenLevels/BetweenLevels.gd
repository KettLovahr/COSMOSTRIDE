extends Control

var module_choices: Array[Dictionary] = [

		{"type": "SHIELD", "level": 1},
		{"type": "SPEED", "level": 1},
		{"type": "SHOT_SPEED", "level": 1},

		{"type": "SPEED", "level": 2},
		{"type": "REGEN", "level": 1},
		{"type": "SHOT_SPEED", "level": 2},
		
		{"type": "SHOT_DAMAGE", "level": 1},
		{"type": "SPEED", "level": 3},
		{"type": "SHIELD", "level": 2},

		{"type": "REGEN", "level": 2},
		{"type": "SHOT_SPEED", "level": 3},
		{"type": "SHOT_DAMAGE", "level": 2},
		
		{"type": "TWIN_FIRE", "level": 1},
		{"type": "SPEED", "level": 3},
		{"type": "SHIELD", "level": 3},
		
		{"type": "REGEN", "level": 3},
		{"type": "SHOT_DAMAGE", "level": 3},

]

var current_choices: Array[Dictionary]

var chosen_module: Dictionary = {  }


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$ColorRect/LevelCompleteText.text = "Level %02d completed!\nCurrent Total Score %06d" % [GameState.level, GameState.total_score]
	
	current_choices = [
		module_choices[min(randi_range(0, 8 + GameState.level), len(module_choices) - 1)],
		module_choices[min(randi_range(0, 8 + GameState.level), len(module_choices) - 1)],
		module_choices[min(randi_range(0, 8 + GameState.level), len(module_choices) - 1)],
		module_choices[min(randi_range(0, 8 + GameState.level), len(module_choices) - 1)],
		module_choices[min(randi_range(0, 8 + GameState.level), len(module_choices) - 1)],
	]
	
	_show_equipped_modules()
	_show_available_modules()

func _process(delta):
	$ColorRect/Current.position = get_viewport().get_mouse_position()

func _on_continue_button_pressed():
	GameState.level += 1
	get_tree().change_scene_to_file("res://Scenes/MainScene/MainScene.tscn")

func _show_equipped_modules():
	for i in range(3):
		var module_icon = GameState.module_icons[GameState.equipped_modules[i].type]
		var tooltip = GameState.module_descriptions[GameState.equipped_modules[i].type]
		var level = GameState.equipped_modules[i].level
		
		var button = get_node("ColorRect/Equipped/Equipped%d" % [i + 1])
		var sprite = get_node("ColorRect/Equipped/Equipped%d/Anchor/Sprite2D" % [i + 1])
		
		sprite.texture = load(module_icon)
		button.tooltip_text = "%s\nLevel %d" % [tooltip, level]
		for connection in button.pressed.get_connections():
			button.pressed.disconnect(connection.callable)
		button.pressed.connect(
			func():
				if chosen_module != { } and chosen_module.type != "EMPTY":
					GameState.equipped_modules[i] = chosen_module
					print(GameState.equipped_modules)
					chosen_module = { }
					$ColorRect/Current.texture = null
				print(chosen_module)
				_show_equipped_modules()
		)


func _show_available_modules():
	for i in range(5):
		var module_icon = GameState.module_icons[current_choices[i].type]
		var tooltip = GameState.module_descriptions[current_choices[i].type]
		var level = current_choices[i].level
		
		var sprite = get_node("ColorRect/Choices/Choice%d/Anchor/Sprite2D" % [i + 1])
		var button = get_node("ColorRect/Choices/Choice%d" % [i + 1])

		sprite.texture = load(module_icon)
		button.tooltip_text = "%s\nLevel %d" % [tooltip, level]
		for connection in button.pressed.get_connections():
			button.pressed.disconnect(connection.callable)
		button.pressed.connect(
			func():
				if chosen_module == { } or chosen_module.type == "EMPTY":
					chosen_module = current_choices[i]
					current_choices[i] = { "type": "EMPTY", "level": 0 }
					print(chosen_module)
					$ColorRect/Current.texture = load(module_icon)
				elif current_choices[i] == { } or current_choices[i].type == "EMPTY":
					current_choices[i] = chosen_module
					chosen_module = { }
					$ColorRect/Current.texture = null
				_show_available_modules()
		)
		
