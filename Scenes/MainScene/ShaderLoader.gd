extends Node3D

var counter: int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node3D.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counter > 0:
		counter -= 1
	elif counter == 0:
		visible = false
		counter = -1
