extends Node3D

var level_length: int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	level_length = 50 + (GameState.level * 5)
	var level_tweener = get_tree().create_tween()
	level_tweener.tween_property($Rails/FollowRail, "progress_ratio", 1.0, level_length)
	level_tweener.tween_callback(finish_level)
	$SpawnTimer.start(level_length - 10)

func finish_level():
	if $Rails/FollowRail/PlayerRoot.alive:
		GameState.total_score += $Rails/FollowRail/PlayerRoot.score
		get_tree().change_scene_to_file("res://Scenes/BetweenLevels/BetweenLevels.tscn")


func _on_spawn_timer_timeout():
	$Rails/FollowRail/EnemySpawner.spawn = false
