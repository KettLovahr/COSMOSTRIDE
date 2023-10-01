extends Node3D

@export var enemies: Array[PackedScene]
@export var patterns: Array[Path3D]

@export var spawn_timer: float = 3.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start(spawn_timer)


func _on_spawn_timer_timeout():
	spawn_enemy()
	$SpawnTimer.start(spawn_timer)

func spawn_enemy():
	var which_pattern = randi_range(0, len(patterns) - 1)
	var which_enemy = randi_range(0, len(enemies) - 1)
	var new_follow = PathFollow3D.new()
	var new_enemy: Enemy = enemies[which_enemy].instantiate()
	patterns[which_pattern].add_child(new_follow)
	new_follow.add_child(new_enemy)
	new_enemy.position += Vector3(randf(), randf() * 3.0, randf()) * randf_range(-1, 1)
	
	new_follow.rotation_mode= PathFollow3D.ROTATION_ORIENTED
		
	var tween = get_tree().create_tween()
	new_follow.progress_ratio = round(randf())
	tween.tween_property(new_follow, "progress_ratio", 1.0 - new_follow.progress_ratio, 12.0)
	tween.tween_callback(func(): if new_follow != null: new_follow.queue_free())
