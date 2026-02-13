extends Label


func _process(delta: float) -> void:
	global_position.y -= 30 * delta
	modulate.a -= 0.4 * delta
	if modulate.a <= 0:
		queue_free()
