extends AudioStreamPlayer

func _on_HurtEffect_finished():
	queue_free()
