extends PanelContainer

@export var armas : arma:
	set(value):
		armas = value
		$TextureRect/AnimatedSprite2D.sprite_frames = value.sprites
		$TextureRect/AnimatedSprite2D.play("default")
		$Recarga.wait_time = value.recarga


func _on_recarga_timeout():
	if armas:
		$Recarga.wait_time = armas.recarga
		var objetivo = owner.enemigo_mascerca
		if not is_instance_valid(objetivo):
			objetivo = null
		armas.activar(owner, objetivo, get_tree())
