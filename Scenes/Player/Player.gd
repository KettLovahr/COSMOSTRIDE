extends Node3D

var world_cursor_pos: Vector3

var can_shoot: bool = true
var gun_delay: float = 0.25

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
	guns = [
		$PlayerController/ModelPosition/PlayerModel/GunLeft,
		$PlayerController/ModelPosition/PlayerModel/GunRight
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	world_cursor_pos = $PlayerCamera.project_position(get_viewport().get_mouse_position(), 100)
	var unprojected_cursor = $PlayerCamera.unproject_position(world_cursor_pos)
	var unprojected_player = $PlayerCamera.unproject_position($PlayerController.global_position)
	$ReticleInner.position = lerp(unprojected_cursor, unprojected_player, 0.10)
	$ReticleOuter.position = lerp(unprojected_cursor, unprojected_player, 0.20)
	
	$PlayerController.look_at(world_cursor_pos)
	if Input.is_action_pressed("move_shoot") and can_shoot:
		var b: Node3D = bullet_scene.instantiate()
		b.top_level = true
		b.target = world_cursor_pos
		add_child(b)
		b.global_position = self.guns[current_gun].global_position
		b.rotation = $PlayerController.rotation
		can_shoot = false
		$ShootDelay.start(gun_delay)
		


func _on_shoot_delay_timeout():
	can_shoot = true
