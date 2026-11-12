extends Area2D

var danio : float
var empuje_fuerza : float
var lado : int = 1    
var distancia : float

const FRAMES_ACTIVOS := [2, 3, 4]

var ya_golpeados : Array = []

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var forma : CollisionShape2D = $CollisionShape2D


func configurar(_lado : int, _danio : float, _distancia : float, _empuje : float, _duracion : float) -> void:
	lado = _lado
	danio = _danio
	distancia = _distancia
	empuje_fuerza = _empuje


func _ready() -> void:
	position = Vector2(distancia * lado, 0)
	sprite.flip_h = lado < 0
	forma.disabled = true

	sprite.sprite_frames.set_animation_loop("morder", false)   # evita que se repita
	sprite.frame_changed.connect(_on_frame_changed)
	sprite.animation_finished.connect(queue_free)
	sprite.play("morder")


func _on_frame_changed() -> void:
	forma.set_deferred("disabled", not (sprite.frame in FRAMES_ACTIVOS))


func _on_body_entered(body: Node2D) -> void:
	if body in ya_golpeados:
		return
	if body.is_in_group("Enemigos") and body.has_method("tomar_daño"):
		ya_golpeados.append(body)
		body.tomar_daño(danio, global_position, empuje_fuerza)
