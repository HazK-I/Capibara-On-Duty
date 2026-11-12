extends TextureButton

var nueva : bool = false

@export var armas : arma:
	set(value):
		armas = value
		$Sprite2D.texture = value.sprites.get_frame_texture("default", 0)
		if nueva:
			$Label.text = "¡Nueva!"
			$Descripcion.text = value.titulo
		else:
			$Label.text = "Nvl " + str(value.nivel)
			$Descripcion.text = value.mejoras[value.nivel - 1].descripcion

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("Tocar") and armas:
		get_parent().elegir(armas)
