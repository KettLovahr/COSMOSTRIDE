extends Area3D

var speed = 10.0
const JUMP_VELOCITY = 4.5

var range: Vector2 = Vector2(3.25, 1.75)
var alive: bool = true

var velocity: Vector2


var display_direction: Vector3 = Vector3.ZERO


func _physics_process(delta):
	var input_dir: Vector2
	if alive:
		input_dir = Input.get_vector("move_left", "move_right", "move_descend", "move_ascend")
	else:
		input_dir = Vector2.ZERO
	if input_dir:
		velocity.x += input_dir.x * speed * delta
		velocity.y += input_dir.y * speed * delta
		velocity.x = clamp(velocity.x, -speed, speed)
		velocity.y = clamp(velocity.y, -speed, speed)

	velocity.x = lerp(velocity.x, 0.0, 0.05)
	velocity.y = lerp(velocity.y, 0.0, 0.05)
	
	display_direction.z = lerp(display_direction.z, -(input_dir.x) * 60.0, 0.05)
	display_direction.x = lerp(display_direction.x, (input_dir.y) * 20.0, 0.05)
	
	position += Vector3(velocity.x, velocity.y, 0) * delta
	position = position.clamp(Vector3(-range.x, -range.y, 0), Vector3(range.x, range.y, 0))
	
	$ModelPosition.rotation_degrees.z = display_direction.z
	$ModelPosition.rotation_degrees.x = display_direction.x
