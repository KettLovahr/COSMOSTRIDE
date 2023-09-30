extends Area3D

const SPEED = 0.2

var target: Vector3
var player: Area3D

var origin: Vector3
var travel_delta: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	reparent(player.get_parent(), true)
	origin = position
	target = player.position
	look_at(to_global(target))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	travel_delta += delta
	position = lerp(origin, target, travel_delta)


func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if "Player" in area.get_groups():
		area.get_parent().cur_health -= 1
		queue_free()

