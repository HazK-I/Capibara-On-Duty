extends Node

func reproducir(sonido : AudioStream, volumen_db : float = -28.0) -> void:
	if sonido == null or get_child_count() >= 8:
		return
	var p = AudioStreamPlayer.new()
	p.stream = sonido
	p.volume_db = volumen_db
	p.pitch_scale = randf_range(0.9, 1.1)
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()
