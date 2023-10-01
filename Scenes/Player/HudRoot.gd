extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		$RestartPanel.visible = not $RestartPanel.visible


func _on_player_root_health_changed(cur_health, max_health):
	# Set the max value first because the engine clamps
	# `value` to the `min_value` and `max_value` properties
	$HealthBar.max_value = max_health
	$HealthBar.value = cur_health


func _on_restart_panel_visibility_changed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if $RestartPanel.visible else Input.MOUSE_MODE_HIDDEN


func _on_restart_yes_pressed():
	GameState.restart()


func _on_restart_no_pressed():
	$RestartPanel.visible = false
