extends Area3D

const SPEED = 20.0
const JUMP_VELOCITY = 4.5

var range: Vector2 = Vector2(3.25, 1.75)

var velocity: Vector2


var display_direction: Vector3 = Vector3.ZERO


func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_descend", "move_ascend")
	if input_dir:
		velocity.x += input_dir.x * SPEED * delta
		velocity.y += input_dir.y * SPEED * delta
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
		velocity.y = clamp(velocity.y, -SPEED, SPEED)

	velocity.x = lerp(velocity.x, 0.0, 0.05)
	velocity.y = lerp(velocity.y, 0.0, 0.05)
	
	display_direction.z = lerp(display_direction.z, -(input_dir.x) * 30.0, 0.05)
	display_direction.x = lerp(display_direction.x, (input_dir.y) * 30.0, 0.05)
	
	position += Vector3(velocity.x, velocity.y, 0) * delta
	position = position.clamp(Vector3(-range.x, -range.y, 0), Vector3(range.x, range.y, 0))
	
	$ModelPosition.rotation_degrees.z = display_direction.z
	$ModelPosition.rotation_degrees.x = display_direction.x
