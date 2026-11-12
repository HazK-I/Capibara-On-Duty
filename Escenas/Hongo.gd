extends armascuerpo
class_name armahongo

@export var area : float = 1.0

func aplicar_mejora(mejora : Mejoras) -> void:
	super(mejora)
	if mejora is MejorasHongo:
		area += mejora.area

func _atacar(origen : Node2D, lado : int) -> void:
	var ataque = escena_ataque.instantiate()
	ataque.configurar(lado, danio, distancia, empuje, duracion)
	ataque.escalar(area)
	origen.add_child(ataque)
