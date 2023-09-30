extends Area3D

const SPEED = 0.2

var target: Vector3
var player: Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	target = player.global_position
	look_at(target)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position = global_position.move_toward(target, SPEED)


func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if "Player" in area.get_groups():
		queue_free()

