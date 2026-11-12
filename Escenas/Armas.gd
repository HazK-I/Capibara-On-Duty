extends Resource
class_name arma

@export var titulo : String
@export var sprites : SpriteFrames
@export var duracion : float
@export var danio : float
@export var recarga : float
@export var sonido_golpe : AudioStream

@export var mejoras : Array[Mejoras]
var nivel = 1

func activar(origen : Node2D, objetivo : Node2D, arbol : SceneTree) -> void:
	pass

func es_mejorable() -> bool:
	if nivel <= mejoras.size():
		return true
	return false

func mejorar_arma():
	if not es_mejorable():
		return
	
	var mejora = mejoras[nivel - 1]
	aplicar_mejora(mejora)
	
	nivel += 1

func aplicar_mejora(mejora : Mejoras) -> void:
	danio += mejora.daño
	recarga += mejora.recarga
