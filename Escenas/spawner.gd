extends Node2D

@export var jugador : CharacterBody2D
@export var enemigo : PackedScene

@export var maximo_enemigos : int = 150              # tope de enemigos vivos a la vez (antes 700)
@export var spawn_por_segundo_base : float = 0.7     # enemigos por segundo en el minuto 0
@export var spawn_extra_por_minuto : float = 0.6     # cuánto sube ese ritmo cada minuto
@export var oleada_base : int = 12                   # tamaño de la oleada en el minuto 0 (antes 75)
@export var oleada_extra_por_minuto : int = 6        # enemigos extra por minuto en cada oleada
@export var intervalo_oleada : float = 30.0          # segundos entre oleadas (antes 10)
@export var intervalo_elite : float = 30.0           # segundos entre enemigos elite/enojados (antes 9)

var distancia : float = 400
var pueden_spawn : bool = true
var acumulado : float = 0.0

@export var tipo_enemigo : Array[Enemigo]

var minuto : int:
	set(value):
		minuto = value
		%Minuto.text = str(value)

var segundos : int:
	set(value):
		segundos = value
		if segundos >= 60:
			segundos -= 60
			minuto += 1
		%Segundos.text = str(segundos).lpad(2,'0')

func _ready():
	$Patter.start(intervalo_oleada)
	$Enojo.start(intervalo_elite)

func _physics_process(_delta):
	pueden_spawn = get_tree().get_node_count_in_group("Enemigos") < maximo_enemigos

func spawn(pos : Vector2, enojo : bool = false):
	if not pueden_spawn and not enojo:
		return
	
	var enemigo_instance = enemigo.instantiate()
	
	get_tree().current_scene.add_child(enemigo_instance)

	enemigo_instance.type = tipo_enemigo[min(minuto, tipo_enemigo.size()-1)]
	enemigo_instance.position = pos
	enemigo_instance.jugador_reference = jugador
	enemigo_instance.enojo = enojo
	
func random_posicion() -> Vector2:
	return jugador.position + distancia * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func cantidad(numero : int = 1):
	for i in range(numero):
		spawn(random_posicion())

func _on_timer_timeout() -> void:
	segundos += 1
	acumulado += spawn_por_segundo_base + minuto * spawn_extra_por_minuto
	var n : int = int(acumulado)
	acumulado -= n
	cantidad(n)


func _on_patter_timeout() -> void:
	for i in range(oleada_base + minuto * oleada_extra_por_minuto):
		spawn(random_posicion())


func _on_enojo_timeout() -> void:
	spawn(random_posicion(), true)
