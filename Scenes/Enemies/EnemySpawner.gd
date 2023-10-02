extends Node3D

var enemies: Array[PackedScene]
@export var patterns: Array[Path3D]

var damage_mult: int = 1
var spawn_timer: float = 3.0

var level_data: Array[Dictionary] = [
	{
		"spawn_timer": 3.0,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn"],
		"damage_multiplier": 1,
	},
	{
		"spawn_timer": 2.0,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn"],
		"damage_multiplier": 1,
	},
	{
		"spawn_timer": 2.5,
		"enemies": ["res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 1,
	},
	{
		"spawn_timer": 2.0,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 2,
	},
	{
		"spawn_timer": 1.5,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 2,
	},
	{
		"spawn_timer": 1.0,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 3,
	},
	{
		"spawn_timer": 1.0,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 3,
	},
	{
		"spawn_timer": 0.75,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 4,
	},
	{
		"spawn_timer": 0.5,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 5,
	},
	{
		"spawn_timer": 0.25,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 6,
	},
	{
		"spawn_timer": 0.15,
		"enemies": ["res://Scenes/Enemies/BasicEnemy.tscn", "res://Scenes/Enemies/Armored.tscn"],
		"damage_multiplier": 6,
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_level_data(GameState.level - 1)
	$SpawnTimer.start(spawn_timer)


func _on_spawn_timer_timeout():
	spawn_enemy()
	$SpawnTimer.start(spawn_timer)

func spawn_enemy():
	var which_pattern = randi_range(0, len(patterns) - 1)
	var which_enemy = randi_range(0, len(enemies) - 1)
	var new_follow = PathFollow3D.new()
	var new_enemy: Enemy = enemies[which_enemy].instantiate()
	new_enemy.gun_damage_mult = damage_mult
	
	patterns[which_pattern].add_child(new_follow)
	new_follow.add_child(new_enemy)
	new_enemy.position += Vector3(randf(), randf() * 3.0, randf()) * randf_range(-1, 1)
	
	new_follow.rotation_mode= PathFollow3D.ROTATION_ORIENTED
		
	var tween = get_tree().create_tween()
	new_follow.progress_ratio = round(randf())
	tween.tween_property(new_follow, "progress_ratio", 1.0 - new_follow.progress_ratio, 12.0)
	tween.tween_callback(func(): if new_follow != null: new_follow.queue_free())
	
func _load_level_data(level: int):
	if level >= len(level_data):
		level = len(level_data) - 1
	spawn_timer = level_data[level]["spawn_timer"]
	enemies = []
	for enemy in level_data[level]["enemies"]:
		enemies.append(load(enemy))
	damage_mult = level_data[level]["damage_multiplier"]
