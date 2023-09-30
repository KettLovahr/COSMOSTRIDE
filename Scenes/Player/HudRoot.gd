extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_root_health_changed(cur_health, max_health):
	# Set the max value first because the engine clamps
	# `value` to the `min_value` and `max_value` properties
	$HealthBar.max_value = max_health
	$HealthBar.value = cur_health
