extends CharacterBody3D
class_name Enemy

@export var explosion_scene: PackedScene
@export var bullet_scene: PackedScene
signal hit(kill: bool, score: int)

@export var value: int = 3

@export var hit_points: int = 3:
	set(v):
		hit.emit(v == 0, value)
		if is_inside_tree():
			$HitSound.play()
		hit_points = v
		if hit_points == 0:
			_on_kill()

func _on_kill():
	var ex: GPUParticles3D = explosion_scene.instantiate()
	ex.top_level = true
	get_tree().root.add_child(ex)
	ex.global_position = global_position
	ex.emitting = true
	queue_free()


func _on_timer_timeout():
	$Timer.start(randf() * 0.5 + 0.2)
	var b = bullet_scene.instantiate()
	add_child(b)
	b.global_position = global_position
