extends Area3D
class_name Bullet

const SPEED = 1.0

var target: Vector3
var damage: int = 1

signal hit(kill: bool, score: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.pitch_scale *= randf_range(0.5, 0.8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = position.move_toward(target, SPEED)


func _on_timer_timeout():
	queue_free()
	
func _on_enemy_hit(kill: bool, score: int):
	hit.emit(kill, score)


func _on_body_entered(body):
	if body is Enemy:
		body.hit.connect(_on_enemy_hit)
		body.hit_points -= damage
		queue_free()
