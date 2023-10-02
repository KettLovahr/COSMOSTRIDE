extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("reparent", get_tree().root)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
