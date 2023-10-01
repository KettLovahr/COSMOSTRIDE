extends Node3D

var world_cursor_pos: Vector3

var can_shoot: bool = true
var gun_delay: float = 0.25

var alive: bool = true

var modules: Array[Module] = []

var score: int = 0:
	set(v):
		score = v
		_update_score()

signal health_changed(cur_health: int, max_health: int)
signal death

var max_health: int = 10:
	set(v):
		health_changed.emit(cur_health, v)
		max_health = v
var cur_health: int = 10:
	set(v):
		health_changed.emit(v, max_health)
		if v < cur_health:
			$HUDLayer/HudRoot/DamageOverlay/DamageAnim.play("OnHit")
			if v > 0:
				$Music/Damage.play()
		if v == 0:
			_die()
		cur_health = v

var current_gun: int = 0
var guns: Array[Node3D]:
	get:
		current_gun += 1
		if current_gun >= len(guns):
			current_gun = 0
		return guns


@export var bullet_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$HUDLayer/HudRoot/LevelLabel.text = "Lv. %02d" % GameState.level
	guns = [
		$PlayerController/ModelPosition/PlayerModel/GunLeft,
		$PlayerController/ModelPosition/PlayerModel/GunRight
	]
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	world_cursor_pos = $PlayerCamera.project_position(get_viewport().get_mouse_position(), 25)
	var unprojected_cursor = $PlayerCamera.unproject_position(world_cursor_pos)
	var unprojected_player = $PlayerCamera.unproject_position($PlayerController.global_position)
	$ReticleInner.position = lerp(unprojected_cursor, unprojected_player, 0.00)
	$ReticleOuter.position = lerp(unprojected_cursor, unprojected_player, 0.15)
	
	if alive:
		$PlayerController.look_at(world_cursor_pos)
		if Input.is_action_pressed("move_shoot") and can_shoot:
			var b: Bullet = bullet_scene.instantiate()
			#b.top_level = true
			b.target = to_local(world_cursor_pos)
			add_child(b)
			b.global_position = self.guns[current_gun].global_position
			b.global_rotation = $PlayerController.global_rotation
			b.hit.connect(_on_bullet_hit)
			can_shoot = false
			$ShootDelay.start(gun_delay)
		

func _on_bullet_hit(kill, score):
	if kill:
		self.score += score

func _on_shoot_delay_timeout():
	can_shoot = true

func _update_score():
	$HUDLayer/HudRoot/ScoreLabel.text = "%03d" % (score)
	$HUDLayer/HudRoot/TotalScoreLabel.text = "%06d" % (GameState.total_score + score)
	
func _die():
	alive = false
	$PlayerController.alive = false
	can_shoot = false
	$PlayerController/ModelPosition/DeathAnim.play("OnDeath")
	$HUDLayer/HudRoot/DeathOverlay/DeathAnim.play("OnDeath")
	$Music/Loop.stop()
	$Music/Death.play()
	GameState.total_score += score
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _end_game():
	get_tree().change_scene_to_file("res://Scenes/GameOver/GameOver.tscn")
