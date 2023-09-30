extends Area3D

const SPEED = 1.0

var target: Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = position.move_toward(target, SPEED)


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body is Enemy:
		body.hit_points -= 1
