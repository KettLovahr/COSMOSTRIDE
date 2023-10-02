extends Node3D

var world_cursor_pos: Vector3

var can_shoot: bool = true
var gun_delay: float = 0.25
var gun_damage: int = 1
var twin_fire: bool = false

var barrel_roll: bool = false
var barrel_roll_delay: float = 10.0

var regen: bool = false
var regen_timer: float = 20.0

var modules: Array[Dictionary]
# Modules to be formatted as such:
# {
#   "type": "module_type"
#   "level": num
# }

var alive: bool = true

var levels: Array[int] = [0,0,0,0,0,0,0]

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
		if v <= 0 and alive:
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

	modules = [

	]

	_apply_module_effects()
	_draw_module_sprites()
	_update_score()


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
			_shoot()
			if twin_fire:
				_shoot()
		

func _on_bullet_hit(kill, score):
	if kill:
		self.score += score * GameState.level

func _on_shoot_delay_timeout():
	can_shoot = true

func _update_score():
	$HUDLayer/HudRoot/ScoreLabel.text = "%03d" % (score)
	$HUDLayer/HudRoot/TotalScoreLabel.text = "%06d" % (GameState.total_score + score)
	
func _shoot():
	var b: Bullet = bullet_scene.instantiate()
	#b.top_level = true
	b.target = to_local(world_cursor_pos)
	add_child(b)
	b.global_position = self.guns[current_gun].global_position
	b.global_rotation = $PlayerController.global_rotation
	b.hit.connect(_on_bullet_hit)
	b.damage = gun_damage
	can_shoot = false
	$ShootDelay.start(gun_delay)
	
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

func _apply_module_effects():
	for module in modules:
		match module.type:
			"SHIELD":
				self.max_health += module.level * 3
				self.cur_health += module.level * 3
			"SPEED":
				$PlayerController.speed += module.level * 3
			"BARREL_ROLL":
				barrel_roll = true
				match module.level:
					1: barrel_roll_delay /= 2.0
					2: barrel_roll_delay /= 2.5
					3: barrel_roll_delay /= 4.0
			"SHOT_SPEED":
				match module.level:
					1: gun_delay -= 0.03
					2: gun_delay -= 0.05
					3: gun_delay -= 0.07
			"SHOT_DAMAGE":
				match module.level:
					1: 
						gun_delay += 0.01
						gun_damage += 1
					2: 
						gun_delay += 0.02
						gun_damage += 2
					3: 
						gun_delay += 0.03
						gun_damage += 4
					
			"TWIN_FIRE":
				twin_fire = true
			"REGEN":
				regen = true
				match module.level:
					1: regen_timer /= 2.0
					2: regen_timer /= 3.0
					3: regen_timer /= 4.0
				$RegenTimer.start(regen_timer)

func _draw_module_sprites():
	var cursor = 1
	for module in modules:
		var sprite: Sprite2D = get_node("HUDLayer/HudRoot/ModuleDisplay/Icon%d" % cursor)
		sprite.texture = load(GameState.module_icons[module.type])
		cursor += 1



func _on_regen_timer_timeout():
	if cur_health < max_health:
		self.cur_health += 1
	$RegenTimer.start(regen_timer)
