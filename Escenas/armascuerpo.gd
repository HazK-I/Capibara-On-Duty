extends arma
class_name armascuerpo

@export var escena_ataque : PackedScene
@export var distancia : float = 45.0
@export var empuje : float = 60.0
@export var ambos_lados : bool = false
@export var solo_frente : bool = false

var atras : bool = false

func activar(origen : Node2D, objetivo : Node2D, arbol : SceneTree) -> void:
	if escena_ataque == null:
		return
	
	Sonidos.reproducir(sonido_golpe)
	
	var mira : int = -1 if origen.get_node("Animacion").flip_h else 1

	if ambos_lados:
		_atacar(origen, mira)
		_atacar(origen, -mira)
	elif solo_frente:
		_atacar(origen, mira)
	else:
		_atacar(origen, -mira if atras else mira)
		atras = not atras

func _atacar(origen : Node2D, lado : int) -> void:
	var ataque = escena_ataque.instantiate()
	ataque.configurar(lado, danio, distancia, empuje, duracion)
	origen.add_child(ataque)
